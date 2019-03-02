# -*- encoding : utf-8 -*-
require 'net/http'
require 'openssl'
require 'json'

class CrazyFusionTable
  
  def access_token
    Rails.cache.fetch "oauth2__fusion__access_token" do
      "ya29.hQEPsfOf_j8wh_8AeXkPoJzK50ocyVOrypTl9dTy4Lt5OqUxrSqyyW8DvjzCAd6qUKfkfdcthBDl7Q"
    end
  end

  def set_access_token(x)
    Rails.cache.write "oauth2__fusion__access_token", x
  end
      
  
  def initialize(table_id)
    @table_id = table_id
    @@refresh_token = "1/Nqt_4NsqFzvitT_dKoThRBY2URxTLRr9Y1Q89rNxLzg"
    @@client_id = "32681293464-u1gf6dg5fkkhgbh69pale12o630hlumf.apps.googleusercontent.com"
    @@client_secret = "Mz5BvPyP-v-_7ILKLPeQ31kg"
  end
  
  def get_row_id(id)
    reply = JSON[query("SELECT ROWID FROM #{@table_id} WHERE ID=#{id}")]['rows']
    reply && reply.first && reply.first.first && reply.first.first.to_i
  end

  def get_row(rowid)
    raise "Bad row id" unless rowid > 0
    data = JSON[query("SELECT * FROM #{@table_id} WHERE ROWID = #{rowid}")]
    data['columns'] or return nil
    data['rows'] or return nil
    cols = data['columns']
    cols.size > 0 or raise "No columns returned"
    rows = data['rows']
    rows.size == 1 or return nil
    row = rows.first 
    (0...cols.size).inject({}){|s,i| s[cols[i]] = row[i]; s}
  end

  def update_row(rowid, data)
    writes = []
    data.each do |c, v|
      writes << "#{c} = '#{v.to_s.gsub("'", "\\'")}'"
    end
    puts pquery("UPDATE #{@table_id} SET #{writes * ", "} WHERE ROWID = '#{rowid}' ")
  end

  def insert_row(data)
    cols, vals = [], []
    data.each do |c, v|
      cols << "#{c}"
      vals << "'#{v.to_s.gsub("'", "\\'")}'"
    end
    pquery("INSERT INTO #{@table_id} (#{cols * ', '}) VALUES (#{vals * ', '}) ")
  end

  def delete_row(rowid)
    pquery("DELETE FROM #{@table_id} WHERE ROWID = '#{rowid}' ")
  end

  def get_new_token
    url = "https://www.googleapis.com/oauth2/v3/token"

    uri = URI.parse(url)
    req = Net::HTTP::Post.new(url)
    req.set_form_data({"client_id" => @@client_id, "client_secret" => @@client_secret, "refresh_token" => @@refresh_token, "grant_type" => "refresh_token"})

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
  
    res = http.request(req)
    
    puts "REFRESH TOKEN"
    puts res.inspect
    puts res.body
  
    set_access_token JSON[res.body]['access_token']
    puts "-> #{access_token}"
  end
  
  def query(q)

    n = 0
    m = 0
    while n < 2 and m < 10
  
      url = "https://www.googleapis.com/fusiontables/v2/query?sql=#{URI.escape q}"
  
      uri = URI.parse(url)
      req = Net::HTTP::Get.new(url)
      req['Authorization'] = "Bearer #{access_token}"

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE # read into this
  
      res = http.request(req)
      if res.code.to_s == '200'
        break
      elsif res.code.to_s == '403'
        m += 1
        sleep m
      else
        get_new_token
        n += 1
      end
    end
    raise "BAD QUERY #{res.code} #{res.body} | #{n} #{m}" if res.code.to_s != '200'
    res.body
  end

  def pquery(q)

    n = 0
    m = 0
    while n < 1 and m < 10
  
      url = "https://www.googleapis.com/fusiontables/v2/query"
  
      uri = URI.parse(url)
      req = Net::HTTP::Post.new(url)
      req['Authorization'] = "Bearer #{access_token}"
      req.set_form_data({"sql" => q})

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE # read into this
  
      res = http.request(req)
      if res.code.to_s == '200'
        break
      elsif res.code.to_s == '403'
        m += 1
        sleep m
      elsif res.code.to_s == '503' and JSON[res.body]['error']['message'] == 'Backend Error'
        m += 1
        sleep m
      else
        get_new_token
        n += 1
      end
    end
    raise "BAD QUERY #{res.code} #{res.body} | #{n} #{m}" if res.code.to_s != '200'
    res.body
  end
  
end


