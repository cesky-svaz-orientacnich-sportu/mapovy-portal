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
#  non_oris_event_url        :string(255)
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
#  shape_geom                :geometry
#  cartographers_for_api     :string(255)
#  color                     :string(255)
#  stroke_color              :string(255)
#  has_embargo               :boolean          default(FALSE), not null
#  embargo_until             :date
#  has_competition_area      :boolean          default(FALSE), not null
#  competition_area_until    :date
#  has_blocking              :boolean          default(FALSE), not null
#  blocking_from             :integer
#  blocking_until            :integer
#  blocking_reason           :text
#  is_educational            :boolean          default(FALSE), not null

class Map < ApplicationRecord

  has_paper_trail ignore: [:user_updated_at, :state_changed_at, :last_reminder_sent_at, :shape_geom]
  nilify_blanks

  belongs_to :created_by, :class_name => 'User', optional: true
  belongs_to :completed_by, :class_name => 'User', optional: true
  belongs_to :approved_by, :class_name => 'User', optional: true
  belongs_to :oris_event, optional: true
  has_many :cartographers, dependent: :destroy
  has_many :authors, through: :cartographers
  accepts_nested_attributes_for :cartographers, :allow_destroy => true

  scope :sorted, ->{ order(:title, :patron, :year, :scale, :id) }
  scope :no_archive_prints, ->{ where(archive_print1_class: [nil, '0', '-'], archive_print2_class: [nil, '0', '-'], archive_print3_class: [nil, '0', '-']) }
  scope :any_archive_prints, ->{ where.not(archive_print1_class: [nil, '0', '-'], archive_print2_class: [nil, '0', '-'], archive_print3_class: [nil, '0', '-']) }

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [
      [:title, :year],
      [:title, :map_sport, :year],
      [:title, :map_sport, :scale, :year],
      [:title, :map_sport, :scale, :club, :year],
    ]
  end

  MAP_TYPES = %w{isom issprom ismtbom isskiom topo iof_4color none military combined}

  ACCURACIES = %w{imprint estimate lookup authored}

  GEOREFERENCES = %w{s_jstk utm unknown none}

  DRAWING_TECHNIQUES = %w{ocad ocad_3 ocad_4 ocad_5 ocad_6 ocad_7 ocad_8 ocad_9 ocad_10 ocad_11 ocad_12 ocad_2018 oo_mapper vector_sw raster_sw pen pencil engraving other}

  PRINTING_TECHNIQUES = %w{spot_1 spot_2 spot_3 spot_4 spot_5 spot_6 spot_7 spot_8 cmyk cmyk_plus_1 cmyk_plus_2 color_copy laser_printer inkjet_printer other cmyk_or_laser}

  MAP_FAMILIES = [
    MAP_FAMILY_MAP = 'map',
    MAP_FAMILY_EMBARGO = 'embargo',
  ]
    MAP_FAMILY_TRAINING_AREA = 'training_area'

  MAP_SPORTS = [
    MAP_SPORT_FOOT = 'foot',
    MAP_SPORT_SPRINT = 'sprint',
    MAP_SPORT_MTBO = 'mtbo',
    MAP_SPORT_SKI = 'ski',
    MAP_SPORT_TRAIL = 'trail',
    MAP_SPORT_EXTREME = 'extreme',
    MAP_SPORT_INDOOR = 'indoor',
    MAP_SPORT_OTHER = 'other',
  ]

  REGIONS = {
    "A" => "Praha",
    "B" => "Jihomoravský kraj",
    "C" => "Jihočeský kraj",
    "E" => "Pardubický kraj",
    "H" => "Královéhradecký kraj",
    "J" => "Kraj Vysočina",
    "K" => "Karlovarský kraj",
    "L" => "Liberecký kraj",
    "M" => "Olomoucký kraj",
    "P" => "Plzeňský kraj",
    "S" => "Středočeský kraj",
    "T" => "Moravskoslezský kraj",
    "U" => "Ústecký kraj",
    "Z" => "Zlínský kraj",
    "X" => "Testovací kraj 1",
    "Y" => "Testovací kraj 2",
  }

  STATES = [
    # filing: first round
    STATE_PROPOSED = 'proposed',
    STATE_APPROVED = 'approved',
      STATE_CHANGE_REQUESTED = 'change_requested',
    # filing: second round
    STATE_COMPLETED = 'completed',
    STATE_FINALIZED = 'finalized',
      STATE_FINAL_CHANGE_REQUESTED = 'final_change_requested',
    # non-filing stuff
    STATE_SAVED_WITHOUT_FILING = 'saved_without_filing',
    # final
    STATE_ARCHIVED = 'archived',
    # dead
    STATE_REMOVED = 'removed',
    # non-map
    STATE_NON_MAP = 'non_map'
  ]

  FULL_STATE_QUERY = "state IN ('proposed', 'change_requested', 'archived', 'saved_without_filing', 'approved', 'completed', 'finalized', 'final_change_requested')"
  STATE_QUERY = "state IN ('archived', 'saved_without_filing', 'approved', 'completed', 'finalized', 'final_change_requested')"

  scope :visible, ->{ where(state: [STATE_APPROVED, STATE_COMPLETED, STATE_FINALIZED, STATE_FINAL_CHANGE_REQUESTED, STATE_SAVED_WITHOUT_FILING, STATE_ARCHIVED]) }
  scope :not_removed, ->{ where('state <> ?', STATE_REMOVED) }

  validates_presence_of :title
  validates_presence_of :map_family
  validates_presence_of :map_sport
  validates_presence_of :state
  validates_presence_of :year

  validates_presence_of :patron, if: :is__proposal?
  validates_presence_of :scale, if: :is__proposal?
  validates_presence_of :equidistance, if: :is__proposal?
  validate :any_event
  validate :date_makes_sense
  validate :valid_geom
  validates_presence_of :region, if: :is__proposal?

  validates_presence_of :patron, if: :is__completion?
  validates_presence_of :scale, if: :is__completion?
  validates_presence_of :equidistance, if: :is__completion?
  validates_presence_of :locality, if: :is__completion?
  #validates_presence_of :oris_event_id, if: :is__completion?
  validates_presence_of :region, if: :is__completion?
  validates_presence_of :administrator, if: :is__completion?
  validates_presence_of :resource, if: :is__completion?
  validates_presence_of :issued_by, if: :is__completion?
  validates_presence_of :printed_by, if: :is__completion?
  validates_presence_of :drawing_technique, if: :is__completion?
  validates_presence_of :printing_technique, if: :is__completion?
  validates_presence_of :georeference, if: :is__completion?
  validates_presence_of :mapping_state, if: :is__completion?

  validates_inclusion_of :state, in: STATES
  validates_inclusion_of :map_family, in: MAP_FAMILIES
  validates_inclusion_of :year_accuracy, in: ACCURACIES, allow_nil: true, allow_blank: true
  validates_inclusion_of :patron_accuracy, in: ACCURACIES, allow_nil: true, allow_blank: true
  validates_inclusion_of :georeference, in: GEOREFERENCES, allow_nil: true, allow_blank: true
  validates_inclusion_of :drawing_technique, in: DRAWING_TECHNIQUES, allow_nil: true, allow_blank: true
  validates_inclusion_of :printing_technique, in: PRINTING_TECHNIQUES, allow_nil: true, allow_blank: true
  validates_inclusion_of :map_type, in: MAP_TYPES, allow_nil: true, allow_blank: true
  validates_inclusion_of :map_sport, in: MAP_SPORTS, allow_nil: true, allow_blank: true
  validates_inclusion_of :region, in: REGIONS.keys, allow_nil: true, allow_blank: true
  validates_numericality_of :year, :blocking_until, :scale, :equidistance, allow_nil: true, allow_blank: true

  def link_to_web
    Mapserver::Application.config.hostname + "/mapa/#{friendly_id || id}"
  end

  def self.load_embargo(year)
    url = "https://vybriz.orientacnisporty.cz/api/?method=getEventCoordsList&year=#{year}&orisonly=1"
    require 'open-uri'
    puts "Opening #{url}"
    data = URI.open(url).read rescue nil
    if data
      puts "Got data from VYBRIZ"
      json = JSON[data] rescue nil
      puts json.inspect
      if json and json['Status'] == 'OK'
        puts json.inspect
        json['Data'].each do |_, event_data|
          vr_id = event_data['ID']
          oris_id = event_data['OrisId']
          attrs = {
            state: STATE_NON_MAP,
            map_family: MAP_FAMILY_EMBARGO,
            year: year,
            identifier_other: "vyberove_rizeni_#{vr_id}"
          }
          map = if m = Map.where(attrs).first
            puts "Found embargo map #{m}"
            m
          else
            puts "Creating new embargo map: #{attrs.inspect}"
            Map.create(attrs)
          end
          map.title ||= "Embargo / VR #{vr_id}"
          map.shape_json = event_data['RaceArea'].to_json
          map.convert_shape_to_kml

          if oris_id and oris_event = OrisEvent.where(oris_id: oris_id).first
            map.oris_event_id = oris_event.id
          end

          oris_url = "https://oris.orientacnisporty.cz/API/?format=json&method=getEvent&id=#{oris_id}"
          odata = URI.open(oris_url).read rescue nil
          if odata
            puts "Got data from ORIS for #{map} on #{oris_url}"
            ojson = JSON[odata] rescue nil
            if ojson and ojson['Status'] == 'OK'
              ojson = ojson['Data']
              if ojson['Name']
                map.title = ojson['Name'] + "(" + ojson['Date'] + ")"
              end
              if ojson['Org1']
                map.patron = ojson['Org1']['Abbr']
              end
              # disciplína je nutná pro `save!` mapy, když k embargu ještě není založená, a vytváříme novou
              if ojson['Sport'] and ojson['Sport']['NameCZ'] == 'OB'
                map.map_sport = 'foot'
              end
            end
          end

          map.save!

          if map.oris_event and !map.oris_event.title.blank?
            map.title = map.oris_event.title
            puts "Updated map title to #{map.title}"
          end
          map.save!
        end
      end
    end
    nil
  end

  def is__current?
    year and year >= 2015
  end

  def is__proposal?
    self.state == Map::STATE_PROPOSED
  end

  def is__completion?
    self.state == Map::STATE_COMPLETED
  end

  def is__rejected_proposal?
    self.state == Map::STATE_CHANGE_REQUESTED
  end

  def set_flags
    self.has_kml = self.has_kml?
    self.has_jpg = self.has_jpg?
  end

  def date_makes_sense
    if !oris_event and !main_race_date.blank?
      unless main_race_date.year > 1900
        errors.add(:main_race_date, I18n.t('errors.messages.invalid'))
      end
    end
  end

  def any_event
    if is__proposal? or is__completion?
      unless oris_event or oris_event_id == 0 or (!main_race_title.blank? and !main_race_date.blank?)
        errors.add(:oris_event_id, I18n.t('errors.messages.blank'))
      end
    end
  end

  def valid_geom
    unless shape_json.blank?
      shape = JSON[shape_json].map do |coord|
        flipped = [coord[1], coord[0]]
        flipped
      end
      begin
        RGeo::GeoJSON.decode("{\"type\":\"Polygon\",\"coordinates\":[#{shape}]}", json_parser: :json)
      rescue RGeo::Error::InvalidGeometry
        errors.add('Obrys mapy', 'netvoří jednu spojitou plochu')
      end
    end
  end

  def convert_shape_to_kml
    unless self.shape_json.blank?
      coords = JSON[self.shape_json]
      self.shape_kml = %{<Polygon><outerBoundaryIs><LinearRing><coordinates>#{coords.map{|x| "#{x[1]},#{x[0]},0.0"} * " "}</coordinates></LinearRing></outerBoundaryIs></Polygon>}
    end
  end

  def convert_shape_to_geom
    unless self.shape_json.blank?
      shape = JSON[self.shape_json].map do |coord|
        flipped = [coord[1], coord[0]]
        flipped
      end
      self.shape_geom = RGeo::GeoJSON.decode("{\"type\":\"Polygon\",\"coordinates\":[#{shape}]}", json_parser: :json)
    end
  end

  def no_archive_prints?
    (archive_print1_class.blank? or (archive_print1_class == '0') or (archive_print1_class == '-')) and
    (archive_print2_class.blank? or (archive_print2_class == '0') or (archive_print2_class == '-')) and
    (archive_print3_class.blank? or (archive_print3_class == '0') or (archive_print3_class == '-'))
  end

  def cartographers_attributes_with_creation=(attrs)

    created_mapping = {}

    puts "CARTOGS: #{attrs.inspect}"
    attrs.each do |kattr, cattr|
      author_id = cattr['author_id']
      if author_id.to_i.to_s != author_id and !author_id.blank?
        if author = created_mapping[author_id]
          cattr['author_id'] = author.id
        else
          author = Author.create(:full_name => author_id)
          puts "CREATED #{author.inspect}"
          created_mapping[author_id] = author
          cattr['author_id'] = author.id
        end
      end
    end

    puts attrs.inspect
    puts cartographers.inspect
    self.cartographers_attributes_without_creation = attrs
    puts cartographers.inspect
    attrs
  end
  alias_method :"cartographers_attributes_without_creation=", :"cartographers_attributes="
  alias_method :"cartographers_attributes=", :"cartographers_attributes_with_creation="

  y0 = Date.today.year

  MAP_YEARS = [
    [y0-2,   nil,     0], # last 3 years
    [y0-8,   y0-3,  -15], # last 4 - 9 years
    [y0-18,  y0-9,  -20], # last 10 - 19 years
    [nil,    y0-19, -25], # 20 years and older
  ]

  REGIONS_OPTIONS = REGIONS.map{|x,y| ["#{x} -- #{y}", x]}

  MAP_FAMILIES_COLOR = {
    MAP_FAMILY_MAP => '#6DE76D',
    MAP_FAMILY_TRAINING_AREA => '#E14B4B',
  }

  MAP_SPORTS_COLOR = {
    MAP_SPORT_FOOT => '#6DE76D',
    MAP_SPORT_SPRINT => '#6DE7BD',
    MAP_SPORT_MTBO => '#E1C34B',
    MAP_SPORT_SKI => '#4B6EE1',
    MAP_SPORT_TRAIL => '#FF00AA',
    MAP_SPORT_EXTREME => '#00AAFF',
    MAP_SPORT_INDOOR => '#FFAA00',
    MAP_SPORT_OTHER => '#B0B0B0',
  }

  DEFAULT_LAYERS = [
    MAP_FAMILY_MAP,
    MAP_SPORT_FOOT,
    MAP_SPORT_SPRINT,
    MAP_SPORT_MTBO,
    MAP_YEARS.first,
  ]

  before_save :set_computed_fields
  after_save :update_authors_activities

  def update_authors_activities
    authors.each do |a|
      a.update_activity
    end
  end

  def created_by_
    created_by&.to_log
  end

  def approved_by_
    approved_by&.to_log
  end

  def club
    Club.where(:abbreviation => patron).first
  end

  def identifier_filing_suffix
    {
      MAP_SPORT_FOOT => 'O',
      MAP_SPORT_SKI => 'L',
      MAP_SPORT_MTBO => 'M',
      MAP_SPORT_TRAIL => 'T',
      MAP_SPORT_SPRINT => 'P',
      MAP_SPORT_EXTREME => 'E',
      MAP_SPORT_INDOOR => 'I',
    }[map_sport] || 'J'
  end

  def proposed_identifier_filing
    return nil if year.blank? or region.blank?
    mask = "%02d%1s___" % [year % 100, region[0..0]]
    rmask = Regexp.compile(mask.sub("___","(\\d\\d\\d)"))
    maps = Map.where("identifier_filing LIKE ?", mask + "_").where("id <> ?", id)
    if maps.any?
      ids = maps.pluck(:identifier_filing).map do |i|
        if m = rmask.match(i)
          m[1].to_i
        else
          0
        end
      end
      n = ((1..ids.max + 1).to_a - ids).first
    else
      n = 1
    end
    "%02d%1s%03d%1s" % [year % 100, region[0..0], n, identifier_filing_suffix]
  end

  def to_label
    "##{id}:#{title}:#{map_family}:#{map_sport}"
  end

  def region_
    REGIONS[region] ? "#{region} -- #{REGIONS[region]}" : region
  end

  def equidistance_
    "#{equidistance.to_f.round(1)} m"
  end

  def scale_
    "1:#{scale}"
  end

  def state_
    I18n.t("mapserver.map_enums.state.#{state}")
  end

  def is_educational_
  	is_educational ? I18n.translate("mapserver.map_enums.is_educational.positive") : I18n.translate("mapserver.map_enums.is_educational.negative")
  end

  def drawing_technique_
    drawing_technique.blank? ? "---" : I18n.t("mapserver.map_enums.drawing_technique.#{drawing_technique}")
  end

  def printing_technique_
    printing_technique.blank? ? "---" : I18n.t("mapserver.map_enums.printing_technique.#{printing_technique}")
  end

  def map_family_
    map_family.blank? ? "---" : I18n.t("mapserver.map_enums.map_family.#{map_family}")
  end

  def map_type_
    map_type.blank? ? "---" : I18n.t("mapserver.map_enums.map_type.#{map_type}")
  end

  def map_sport_
    map_sport.blank? ? "---" : I18n.t("mapserver.map_enums.map_sport.#{map_sport}")
  end

  def year_accuracy_
    year_accuracy.blank? ? "---" : I18n.t("mapserver.map_enums.accuracy.#{year_accuracy}")
  end

  def patron_accuracy_
    patron_accuracy.blank? ? "---" : I18n.t("mapserver.map_enums.accuracy.#{patron_accuracy}")
  end

  def is_educational_
    is_educational ? "ano" : "ne"
  end

  def embargo?
    map_family == MAP_FAMILY_EMBARGO
  end

  def competition_area?
    (map_family != MAP_FAMILY_EMBARGO) and (
    !identifier_filing.blank? and (identifier_filing.size >= 3) and [STATE_APPROVED, STATE_COMPLETED, STATE_FINALIZED, STATE_FINAL_CHANGE_REQUESTED, STATE_ARCHIVED].include?(state) and (oris_event || main_race_date)
    )
  end

  def blocking?
    !identifier_filing.blank? and (identifier_filing.size >= 3) and [STATE_FINALIZED, STATE_ARCHIVED].include?(state)
  end

  def race_date
    if oris_event
      oris_event.date
    elsif main_race_date
      main_race_date
    else
      nil
    end.try(:to_date)
  end

  def set_computed_fields
    convert_shape_to_geom
    set_cartographers_for_api
    set_color
    set_stroke_color
    set_embargo
    set_competition_area
    set_blocking
    unset_oris_url
  end

  def set_cartographers_for_api
    self.cartographers_for_api = cartographers.exists? ? (cartographers.map{|c| "[#{c.role.downcase}:#{c.author_id}]"} * "") : "0"
  end

  def set_color
    c = '#CCCCCC'
    if map_family == MAP_FAMILY_MAP
      c = MAP_SPORTS_COLOR[map_sport] || '#CCCCCC'
      saturation = 0
      MAP_YEARS.each do |y1, y2, s|
        saturation = s if ((!y1) || (year >= y1)) and ((!y2) || (year <= y2))
      end
      c = '#CCCCCC' if c.blank?
      c = Color::RGB::from_html(c).adjust_saturation(saturation).adjust_brightness(saturation).html
    else
      c = MAP_FAMILIES_COLOR[map_family] || '#CCCCCC'
    end
    c = '#CCCCCC' if c.blank?
    self.color = c
  end

  def set_stroke_color
    self.stroke_color = Color::RGB::from_html(self.color).adjust_saturation(1).adjust_brightness(1).html
  end

  def set_embargo
    self.has_embargo = embargo? ? 1 : 0
    self.embargo_until = embargo? ? race_date || Date.civil(1970,1,1) : Date.civil(1970,1,1)
  end

  def set_competition_area
    self.has_competition_area = competition_area? ? 1 : 0
    self.competition_area_until = competition_area? ? race_date || Date.civil(1970,1,1) : Date.civil(1970,1,1)
  end

  def set_blocking
    self.has_blocking = blocking? ? 1 : 0
    self.blocking_from = blocking? ? year : 0
  end

  def unset_oris_url
    if oris_event and oris_event_id != 0
      self.non_oris_event_url = nil
    end
  end

  def cartographers_with_roles
    set = {}
    cartographers.each do |c|
      set[c.author] ||= []
      set[c.author] |= [c.role]
    end
    set
  end

  def shape_as_coords
    unless shape_json.blank?
      return JSON[shape_json].map(&:reverse)
    end
    return []
  end

  def create_duplicate
    self.reclaim_shape
    m = self.dup
    m.preview_identifier = nil
    m.identifier_filing = nil
    m.approved_by = nil
    m.title += " [copy ID="
    m.save
    m.title += "#{m.id}]"
    m.save
    m
  end

  def reclaim_shape
    if self.shape_json.blank?
      a = shape_as_coords
      unless a.blank?
        aa = a.map{|x| [x[1], x[0]]}
        self.shape_json = aa.to_json
        convert_shape_to_kml
        convert_shape_to_geom
        save
      end
    end
  end

  def to_s
    title.blank? ? "##{id}" : title
  end

  def preview_path
    "/data/jpg/#{preview_identifier}.jpg"
  end

  def preview_filename
    File.join(Rails.root, 'public', 'data', 'jpg', "#{preview_identifier}.jpg")
  end

  def has_jpg?
    if preview_identifier.blank?
      false
    else
      File.exist?(preview_filename)
    end
  end

  def preview_full_jpg_filename
    File.join(Rails.root, 'public', 'data', 'jpg', "original", "_#{preview_identifier}.jpg")
  end

  def preview_original_filename
    candidates = [
      File.join(Rails.root, 'public', 'data', 'jpg', "original", "#{preview_identifier}.jpg"),
      File.join(Rails.root, 'public', 'data', 'jpg', "original", "#{preview_identifier}.png"),
      File.join(Rails.root, 'public', 'data', 'jpg', "original", "#{preview_identifier}.pdf"),
      File.join(Rails.root, 'public', 'data', 'jpg', "original", "#{preview_identifier}.tif"),
      File.join(Rails.root, 'public', 'data', 'jpg', "original", "#{preview_identifier}.tiff"),
    ]
    candidates.detect{|x| File.exist?(x)}
  end

  def has_original_jpg?
    if preview_identifier.blank?
      false
    else
      preview_full_jpg_filename and File.exist?(preview_full_jpg_filename)
    end
  end

  def has_original_preview?
    if preview_identifier.blank?
      false
    else
      !!preview_original_filename
    end
  end

  def has_tif?
    if preview_identifier.blank?
      false
    else
      File.exist?(File.join(Rails.root, 'public', 'data', 'jpg', "original", "#{preview_identifier}.tiff")) or
      File.exist?(File.join(Rails.root, 'public', 'data', 'jpg', "original", "#{preview_identifier}.tif"))
    end
  end

  def has_kml?
    File.exist?(File.join(Rails.root, 'public', 'data', 'kml', "#{id}.kml"))
  end

  def upload_preview(html_file)
    puts "-> uploading preview"
    tmp = html_file.tempfile
    ext = html_file.original_filename.to_s.split(".").last.downcase
    fn = File.join("public", "data", "jpg", "original", "#{self.id}X.#{ext}")
    FileUtils.mkdir_p(File.dirname(fn))
    FileUtils.cp tmp.path, fn
    FileUtils.chmod 0644, fn
    puts "-> saved as #{fn}"

    path = File.join(Rails.root, "public", "data", "jpg", "original")

    ofn = File.expand_path("../#{File.basename(fn).split(".").first}.jpg", path)
    _fn = File.expand_path("_" + "#{File.basename(fn).split(".").first}.jpg", path)
    __fn = File.join(File.dirname(_fn), "_" + File.basename(_fn))

    Dir.chdir(File.join(Rails.root, "public")) do
      Bundler.with_unbundled_env do
        system("rbenv shell 2.7.6 ; ./cream #{self.id}X.#{ext}")
      end
    end

    puts "Processed to:"
    puts " - convert : #{_fn}"
    puts " - downsample : #{__fn}"
    puts " - watermark : #{ofn}"

    self.preview_identifier = "#{self.id}X"
  end

  def remove_preview
    if self.preview_identifier and  self.preview_identifier =~ /^\d+[a-zA-Z]$/
      fn = File.join(Rails.root, "public", "data", "jpg", "#{self.preview_identifier}.jpg")
      File.delete(fn) if File.exist?(fn)
      fn = File.join(Rails.root, 'public', 'data', 'kml', "#{id}.kml")
      File.delete(fn) if File.exist?(fn)
      Dir[File.join(Rails.root, "public", "data", "jpg", "original", "#{self.preview_identifier}.*")].each do |fn|
        File.delete(fn)
      end
    end

    self.update(:preview_identifier => "#{self.id}X")
  end

  def authorized_cartographers(extra_region = nil)
    return [] if region.blank?
    User.where(role: 'cartographer').select do |u|
      u.regions.include?(region) or u.regions.include?(extra_region)
    end
  end

  def authorized_cartographer?(user)
    return false unless user
    user.has_role?(:manager) or
    user.has_role?(:cartographer) && !region.blank? && user.regions.include?(region)
  end

  def authorized_organizer?(user)
    return false unless user
    user.has_role?(:manager) or
    user.has_role?(:cartographer) or
    user.has_role?(:organizer) && created_by && created_by == user  or
    user.has_role?(:organizer, :cartographer, :manager) && club && user.clubs.include?(club.abbreviation)
  end

  def log(s)
    if record_log.blank?
      self.record_log = Time.now.strftime("[%d. %m. %Y %H:%M] ") + s
    else
      self.record_log += ("\n" + Time.now.strftime("[%d. %m. %Y %H:%M] ") + s)
    end
    save
  end

  def authorized_to_destroy?(user)
    return false unless user
    return true if user.has_role? :manager
    return true if [STATE_PROPOSED, STATE_SAVED_WITHOUT_FILING].include?(state) and created_by == user
    false
  end

  def archive_
    if archive_print1_class.blank?
      "---"
    else
      "#{archive_print1_class}#{archive_print2_class}#{archive_print3_class}#{archive_extra_print_count}"
    end
  end

  def reminder__on_proposed
    if state == STATE_PROPOSED and state_changed_at
      dt = (Date.today - state_changed_at).to_i
      if dt == 2 or ((dt - 2) % 3 == 0 and (dt - 2) / 3 > 0)
        !last_reminder_sent_at or Date.today > last_reminder_sent_at
      end
    end
  end

  def reminder__on_requested_change?
    if (state == STATE_CHANGE_REQUESTED or state == STATE_FINAL_CHANGE_REQUESTED) and state_changed_at
      dt = (Date.today - state_changed_at).to_i
      if dt == 2 or ((dt - 2) % 7 == 0 and (dt - 2) / 7 > 0)
        !last_reminder_sent_at or Date.today > last_reminder_sent_at
      end
    end
  end

  def reminder__before_completed?
    if state == STATE_APPROVED and race_date
      dt = (Date.today - race_date).to_i
      if [1,10,20,30].include?(dt) or dt > 30
        !last_reminder_sent_at or Date.today > last_reminder_sent_at
      end
    end
  end

end
