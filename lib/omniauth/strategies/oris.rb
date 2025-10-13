require 'omniauth'

module OmniAuth
  module Strategies
    class Oris
      include OmniAuth::Strategy

      def initialize(app, client_id, client_secret, options = {})
        @id = client_id
        @secret = client_secret
        super(app, options)
      end

      def request_phase
        unless session['oris.token'].present?
          require 'date'
          require 'digest/md5'
          session['oris.token'] = SecureRandom.hex(24)
        end
        redirect "https://oris.ceskyorientak.cz/ssologin?cid=#{@id}&uid=#{session['oris.token']}"
      end

      uid do
        request.params['uid']
      end

      info do
        require 'open-uri'
        data = URI.open("https://oris.ceskyorientak.cz/API/?format=json&method=ssoUser&cid=#{@id}&csc=#{@secret}&uid=#{session['oris.token']}").read rescue nil
        res = {}
        if data
          json = JSON[data] rescue nil
          if json and json['Status'] == 'OK'
            user = json['Data']
            regs = [];
            user['ClubMembers'].each do |k,c|
              regs << c['RegNum']
            end
            res = {
              'email' => user['Email'].downcase,
              'name' => "#{user['FirstName']} #{user['LastName']}",
              'authorized_clubs' => regs
            }.reject{|k,v| v.nil? || (v.is_a?(String) && v.strip == '') || (v.is_a?(Array) && v.empty?)}
          end
        end
        res
      end

      def callback_phase
        return fail!(:invalid_credentials) unless request.params['uid'].present? and uid == session['oris.token']
        super
      end
    end
  end
end
