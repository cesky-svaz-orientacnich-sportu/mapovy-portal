# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: maps
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  patron                    :string(255)
#  patron_accuracy           :string(255)
#  year                      :integer
#  year_accuracy             :string(255)
#  scale                     :integer
#  archive_print1_class      :string(255)
#  archive_print2_class      :string(255)
#  archive_print3_class      :string(255)
#  archive_extra_print_count :integer
#  equidistance              :float
#  identifier_other          :string(255)
#  locality                  :string(255)
#  area_size                 :float
#  issued_by                 :string(255)
#  printed_by                :string(255)
#  map_type                  :string(255)
#  drawing_technique         :string(255)
#  printing_technique        :string(255)
#  resource                  :string(255)
#  main_race_title           :string(255)
#  main_race_date            :date
#  non_oris_event_url        :string(255)
#  administrator             :text
#  identifier_approval       :string(255)
#  identifier_filing         :string(255)
#  note_public               :text
#  note_internal             :text
#  preview_identifier        :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  created_by_id             :integer
#  map_family                :string(255)
#  map_sport                 :string(255)
#  oris_event_id             :integer
#  shape_json                :text
#  shape_kml                 :text
#  georeference              :string(255)
#  region                    :string(255)
#  state                     :string(255)
#  record_log                :text
#  approved_by_id            :integer
#  mapping_state             :string(255)
#  slug                      :string(255)
#  has_jpg                   :boolean          default(FALSE), not null
#  has_kml                   :boolean          default(FALSE), not null
#  administrator_email       :string(255)
#  last_reminder_sent_at     :date
#  state_changed_at          :date
#  completed_by_id           :integer
#  user_updated_at           :datetime
#

class MapsController < ApplicationController

  require 'fileutils'

  before_action :require_admin, only: [:destroy]
  before_action :require_manager, only: [:racematch]
  before_action :require_contributor, only: [:edit, :new, :create, :remove]
  before_action :require_organizer, only: [:register]
  before_action :require_cartographer, only: [:authorize_proposal, :reject_proposal, :authorize_completion, :reject_completion]
  before_action :require_any_user, only: [:my_approved]

  before_action :use_map, only: [:new, :show, :edit, :register, :re_register, :complete, :create, :update]

  before_action :set_paper_trail_whodunnit

  def export_objev_sok
    @maps = Map.where("is_educational IS TRUE")
    respond_to do |format|
      format.json do
        render json: @maps.to_json, layout: false
      end
      format.xml do
        render xml: @maps.to_xml, layout: false
      end
    end
  end

  def filed
    @year = params[:year] || Date.today.year
  end

  def check_map_title
    id, year, title = params[:id], params[:year], params[:title]
    maps = Map.where(year: year, title: title).not_removed
    maps = maps.where('id <> :id', id: id) if id
    if maps.any?
      render :plain => ("<p>Název + rok je shodný u těchto map:</p><ul>" + maps.map{|m| view_context.link_to("#{m.title} [#{m.year}, #{m.patron}]", m)}.join + "</ul>").html_safe
    else
      render plain: 'OK'
    end
  end

  def new
    state = nil
    if has_role?(:manager)
      @states = [Map::STATE_SAVED_WITHOUT_FILING, Map::STATE_FINALIZED, Map::STATE_ARCHIVED]
      state = Map::STATE_ARCHIVED
    else
      state = Map::STATE_SAVED_WITHOUT_FILING
    end
    @disable_blocking = true # map created without registrations isn't eligible for blocking
    @map = Map.new(created_by_id: current_user.id, map_family: Map::MAP_FAMILY_MAP, state: state, patron_accuracy: 'authored', year_accuracy: 'authored')
  end

  def compare
    if params[:ids]
      @maps = params[:ids].map{|id| Map.visible.where(id: id).first}.compact
    else
      redirect_to :maps
    end
  end

  def table_search
    @list = params[:list].split("-").map(&:to_i).uniq if params[:list]
    @maps = @list ? Map.where(:id => @list).order(:title).page(params[:page]).per(20) : nil
  end

  def download_all
    @maps = Map.order(:title)

    fn = Date.today.strftime("mapy-vsechny--%Y-%m-%d")

    document_columns = [
      :id                 ,
      :state              ,
      :title              ,
      :patron             ,
      :patron_accuracy    ,
      :year               ,
      :year_accuracy      ,
      :scale              ,
      :equidistance       ,
      :map_sport_         ,
      :map_type_          ,
      :map_family         ,
      :region             ,
      :locality           ,
      :area_size          ,
      :resource           ,
      :georeference       ,
      :mapping_state      ,
      :drawing_technique  ,
      :printing_technique ,
      :issued_by          ,
      :printed_by         ,
      :administrator      ,
      :identifier_filing  ,
      :identifier_approval,
      :identifier_other   ,
      :archive_           ,
      :note_public        ,
      :note_internal      ,
      :created_by_        ,
      :approved_by_       ,
      :oris_event         ,
      :main_race_title    ,
      :main_race_date     ,
      :non_oris_event_url ,
      :link_to_web        ,
      :is_educational_    ,
      :blocking_until     ,
      :blocking_reason    ,
    ]

    document_headers = document_columns.map{|x| t("mapserver.map_attributes.#{x[-1..-1]=='_' ? x[0...-1] : x}")}

    respond_to do |format|
      format.csv do
        require 'csv'
        csv = CSV.generate(:encoding => 'utf-8') do |c|
          c << document_headers
          @maps.each do |m|
            c << document_columns.map do |x|
              m.send(x)
            end
          end
        end
        send_data csv, filename: "#{fn}.csv"
      end
      format.xls do
      	document_columns = document_columns.map { |c| c == :oris_event ? {:oris_event => :to_s} : c }
        file = @maps.to_xls(columns: document_columns, headers: document_headers)
        send_data file, filename: "#{fn}.xls"
      end
    end
  end

  def download_search
    @list = params[:list].split("-").map(&:to_i).uniq if params[:list]
    @maps = @list ? Map.where(:id => @list).order(:title) : []

    document_columns = [:title, :scale, :locality, :map_type_, :map_sport_, :patron, :year]
    document_headers = document_columns.map{|x| t("mapserver.map_attributes.#{x}")}

    respond_to do |format|
      format.html
      format.csv do
        require 'csv'
        csv = CSV.generate(:encoding => 'utf-8') do |c|
          @maps.each do |m|
            c << document_columns.map do |x|
              m.send(x)
            end
          end
        end
        send_data csv, filename: "mapy-vyber.csv"
      end
      format.xls do
        file = @maps.to_xls(columns: document_columns, headers: document_headers)
        send_data file, filename: "mapy-vyber.xls"
      end
    end
  end

  def list
    respond_to do |format|
      format.html
      format.json do
        render json: MapsListDatatable.new(view_context)
      end
    end
  end

  def list_for_select
    respond_to do |format|
      format.json do
        if q = params[:q]
          render json: {
            results: Map.where("LOWER(title) LIKE ?", "%" + params[:q].downcase + "%").order(:title).map{|m| {id: m.id, text: "#{m} [#{m.id}]"}}
          }.to_json
        else
          render json: {}
        end
      end
    end
  end

  def index
    respond_to do |format|
      format.html
      format.json do
        if abbr = params[:filter_by_club]
          render json: MapsDatatable.new(view_context, Map.visible.where(map_family: Map::MAP_FAMILY_MAP).where(:patron => abbr))
        elsif aid = params[:filter_by_author]
          render json: MapsDatatable.new(view_context, Author.find(aid).maps.visible)
        elsif lst = params[:filter_by_ids]
          render json: MapsDatatable.new(view_context, Map.visible.where(map_family: Map::MAP_FAMILY_MAP).where(:id => lst))
        else
          render json: MapsDatatable.new(view_context, Map.visible.where(map_family: Map::MAP_FAMILY_MAP))
        end
      end
    end
  end

  def check_kml
    @map = Map.where(:id => params[:id]).first
    if @map and @map.has_kml?
      render :status => 200, :text => 'OK'
    else
      render :status => 404, :text => 'Not found'
    end
  end

  def check_jpg
    @map = Map.where(:id => params[:id]).first
    if @map and @map.has_jpg?
      render :status => 200, :text => 'OK'
    else
      render :status => 404, :text => 'Not found'
    end
  end

  def show
    @map = Map.find(params[:id])
    if @map.state == Map::STATE_REMOVED and (!current_user or !current_user.authorized_to_view_removed_map?)
      render :file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false
    end
    respond_to do |format|
      format.html
      format.json do
        render json: @map
      end
    end
  end

  def remove
    @map = Map.find(params[:id])
    if @map.authorized_to_destroy?(current_user)
      @map.update_attribute :identifier_filing, nil if @map.state == Map::STATE_PROPOSED
      @map.update_attribute :state, Map::STATE_REMOVED
      flash[:error] = "Mapa #{@map} označena jako zrušená."
      if params.has_key?(:redirect_to)
        redirect_to params[:redirect_to]
      else
        redirect_to current_user.authorized_to_view_removed_map? ? { action: 'show', id: params[:id] } : { controller: 'maps', action: 'index' }
      end
    else
      flash[:error] = "Uživatel #{current_user} nemá oprávnění smazat mapu #{@map}!"
      if params.has_key?(:redirect_to)
        redirect_to params[:redirect_to]
      else
        redirect_back fallback_location: { action: 'show', id: params[:id] }
      end
    end
  end

  def destroy
    @map = Map.find(params[:id])
    if admin?
      @map.remove_preview
      @map.destroy
      flash[:error] = "Mapa #{@map} odstraněna."
      if params.has_key?(:redirect_to)
        redirect_to params[:redirect_to]
      else
        redirect_back fallback_location: { action: 'index' }
      end
    else
      flash[:error] = "Uživatel #{current_user} nemá oprávnění smazat mapu #{@map}!"
      if params.has_key?(:redirect_to)
        redirect_to params[:redirect_to]
      else
        redirect_back fallback_location: { action: 'show', id: params[:id] }
      end
    end
  end

  def fusion
    @map = Map.find(params[:id])
    redirect_to view_context._map_path(@map)
  end

  def edit
    @map = Map.find(params[:id])

    if has_role?(:manager)
      @states = [Map::STATE_SAVED_WITHOUT_FILING, Map::STATE_FINALIZED, Map::STATE_ARCHIVED]
    elsif current_user and @map.created_by == current_user
      if @map.state == Map::STATE_PROPOSED
        redirect_to action: :register, id: @map.id
      end
    else
      render plain: "Not authorized.", status: 403
    end
  end

  def complete
    @map = Map.find(params[:id])
    unless current_user && (has_role?(:manager) or @map.created_by == current_user)
      render plain: "Not authorized.", status: 403
    end
    @map.state = Map::STATE_COMPLETED
    @map.state_changed_at = Date.today
    @map.user_updated_at = Time.now
    @map.completed_by = current_user
    if request.put? or request.patch?
      @map.assign_attributes(params[:map])
      if !params[:map][:main_race_date].blank? and (!@map.main_race_date or (params[:map][:main_race_date].to_s !~ /^\d\d\d\d-\d{1,2}-\d{1,2}$/))
        @map.main_race_date = Date.civil(1,1,1)
      end
      if @map.save

        @map.upload_preview(params[:file]) if params[:file]
        @map.convert_shape_to_kml
        @map.set_flags
        @map.save

        @map.log("Uživatel #{current_user.to_log} doplnil údaje po vydání mapy.")
        MapStateMailer.map_completed(@map).deliver

        redirect_to @map
      else
        render
      end
    end
  end

  def update
    @map = Map.find(params[:id])
    unless current_user && (has_role?(:manager) or @map.created_by == current_user)
      render plain: "Not authorized.", status: 403
      return
    end

    @map.user_updated_at = Time.now
    @map.assign_attributes(params[:map])
    if !params[:map][:main_race_date].blank? and (!@map.main_race_date or (params[:map][:main_race_date].to_s !~ /^\d\d\d\d-\d{1,2}-\d{1,2}$/))
      @map.main_race_date = Date.civil(1,1,1)
    end
    if @map.save

      if params[:remove_file] or @map.has_jpg? && params[:file]
        @map.remove_preview
      end

      if params[:file]
        puts "Will upload preview : #{params[:file].inspect}"
        @map.upload_preview(params[:file])
      else
        puts "No preview given!"
      end
      @map.convert_shape_to_kml
      @map.set_flags
      @map.save

      redirect_to @map
    else
      render action: :edit
    end
  end

  def re_register
    @map = Map.find(params[:id])
    render action: :register
  end

  def register
    do_assign = nil
    if params[:map]
      if params[:map][:id] && !params[:map][:id].blank? && params[:map][:id].to_i > 0
        @map = Map.find(params[:map][:id])
        do_assign = params[:map]
      else
        @map = Map.new(params[:map])
      end
      if !params[:map][:main_race_date].blank? and (!@map.main_race_date or (params[:map][:main_race_date].to_s !~ /^\d\d\d\d-\d{1,2}-\d{1,2}$/))
        @map.main_race_date = Date.civil(1,1,1)
      end
      @map.valid?
    elsif params[:id]
      @map = Map.find(params[:id])
    else
      @map = Map.new(created_by_id: current_user.id, year: Date.today.year, patron_accuracy: 'authored', year_accuracy: 'authored', map_family: Map::MAP_FAMILY_MAP, state: Map::STATE_PROPOSED)
      if params[:copy_shape_id]
        m = Map.find(params[:copy_shape_id])
        @map.shape_json = m.shape_json
        @map.shape_kml = m.shape_kml
      end
    end

    new_map = @map.new_record?
    region_was = @map && @map.region
    year_was = @map && @map.year
    map_sport_was = @map && @map.map_sport
    do_not_send = (@map.state == Map::STATE_PROPOSED)
    @map.assign_attributes(do_assign) if do_assign
    @map.state = Map::STATE_PROPOSED
    @map.state_changed_at = Date.today
    @map.user_updated_at = Time.now

    if request.post? or request.put? or request.patch?
      if @map.valid?
        @map.save

        if region_was and @map.region != region_was
          do_not_send = false
        end

        @map.update_attribute(:identifier_filing, nil) if @map.region != region_was
        @map.update_attribute(:identifier_filing, nil) if @map.year != year_was

        @map.identifier_filing ||= @map.proposed_identifier_filing
        if @map.map_sport != map_sport_was and !@map.identifier_filing.blank?
          @map.identifier_filing = @map.identifier_filing[0...-1] + @map.identifier_filing_suffix
        end

        @map.convert_shape_to_kml
        @map.save
        if !new_map
          unless do_not_send
            @map.log("Uživatel #{current_user.to_log} doplnil požadované informace")
            @map.log("Uživatel #{current_user.to_log} změnil kraj z #{Map::REGIONS[region_was]} na #{Map::REGIONS[@map.region]}") if @map.region != region_was
            MapStateMailer.map_changed_after_request(@map, region_was).deliver
          end
        else
          @map.log("Uživatel #{current_user.to_log} požádal o přidělení evidenčního čísla")
          MapStateMailer.map_proposed(@map).deliver
        end

        @map = Map.find(@map.id)
        redirect_to @map
      end
    end
  end

  def copy
    map = Map.find(params[:id])
    @map = map.create_duplicate
    @map.created_by = current_user
    @map.user_updated_at = Time.now

    if has_role?(:manager)
      @map.state = Map::STATE_ARCHIVED
    else
      @map.state = Map::STATE_SAVED_WITHOUT_FILING
    end

    @map.save
    @map.log("Uživatel #{current_user.to_log} vytvořil kopii ze záznamu #{map.to_label}")

    redirect_to [:edit, @map]
  end

  def create
    @map = Map.new(params[:map])
    if !params[:map][:main_race_date].blank? and (!@map.main_race_date or (params[:map][:main_race_date].to_s !~ /^\d\d\d\d-\d{1,2}-\d{1,2}$/))
      @map.main_race_date = Date.civil(1,1,1)
    end

    if @map.save
      @map.user_updated_at = Time.now
      @map.convert_shape_to_kml
      @map.save
      if params[:file]
        @map.upload_preview(params[:file])
        @map.set_flags
        @map.save
      end

      @map.log("Uživatel #{current_user.to_log} vytvořil nový záznam")

      redirect_to @map
    else
      render action: :new
    end
  end

  def original_jpg
    @map = Map.find(params[:id])
    if fn = @map.preview_original_filename and has_role?(:manager)
      send_file fn, disposition: :inline
    else
      head 404, "content_type" => "text/plain"
    end
  end

  def info_table
    @map = Map.find(params[:id])
    I18n.locale ||= :cs
    render :layout => 'info_table', :action => :show_for_info
  end

  def by_user
    @user = User.find(params[:user_id])
  end

  def filter_oris_events
    y = params[:year].to_i
    list = if OrisEvent.years.include?(y)
      OrisEvent.in_year(y).sorted
    else
      OrisEvent.sorted
    end
    render plain: ("<option value=\"\"></option><option value=\"0\">(žádný závod)</option>".html_safe + view_context.options_from_collection_for_select(list, :id, :to_label))
  end

  def authorize_proposal
    @map = Map.find(params[:id])
    @map.log "Záznam byl uživatelem #{current_user.to_log} přijat."
    @map.state = Map::STATE_APPROVED
    @map.state_changed_at = Date.today
    @map.approved_by_id = current_user.id
    @map.user_updated_at = Time.now
    @map.blocking_until = params[:map][:blocking_until]
    @map.blocking_reason = params[:map][:blocking_reason]
    @map.save
    MapStateMailer.map_approved(@map).deliver
    redirect_to @map
  end

  def reject_proposal
    @map = Map.find(params[:id])
    @map.log "Záznam byl uživatelem #{current_user.to_log} zamítnut a předán zpět žadateli k doplnění."
    @map.state = Map::STATE_CHANGE_REQUESTED
    @map.state_changed_at = Date.today
    @map.approved_by_id = current_user.id
    @map.user_updated_at = Time.now
    @map.save
    comment = params[:map][:comment]
    unless comment.blank?
      @map.log "Komentář: #{comment}"
    end
    MapStateMailer.map_rejected(@map, comment).deliver
    redirect_to @map
  end

  def authorize_completion
    @map = Map.find(params[:id])
    @map.log "Záznam byl uživatelem #{current_user.to_log} schválen."
    @map.state = Map::STATE_FINALIZED
    @map.state_changed_at = Date.today
    @map.approved_by_id = current_user.id
    @map.user_updated_at = Time.now
    @map.blocking_until = params[:map][:blocking_until]
    @map.blocking_reason = params[:map][:blocking_reason]
    @map.save
    redirect_to @map
  end

  def reject_completion
    @map = Map.find(params[:id])
    @map.log "Záznam byl uživatelem #{current_user.to_log} zamítnut a předán zpět žadateli k doplnění."
    @map.state = Map::STATE_FINAL_CHANGE_REQUESTED
    @map.state_changed_at = Date.today
    @map.approved_by_id = current_user.id
    @map.user_updated_at = Time.now
    @map.save
    comment = params[:map][:comment]
    unless comment.blank?
      @map.log "Komentář: #{comment}"
    end
    MapStateMailer.map_completion_rejected(@map, comment).deliver
    redirect_to @map
  end

  def racematch
    if request.post?
      map2oris = {}
      params['map'].each do |oris_event_id, map_id|
        unless map_id.blank?
          map2oris[map_id] = oris_event_id
        end
      end
      render plain: "<p>Changed maps: " + map2oris.inspect + "</p>", layout: true
    end
  end

  def update_oris_data
    @map = Map.find(params[:id])
    OrisEvent.find(@map.oris_event_id).fetch
    redirect_to @map
  end

end
