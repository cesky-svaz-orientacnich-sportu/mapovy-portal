class TrimTitle < ActiveRecord::Migration
  def up
    Map.find_each do |m|
      print "."
      $stdout.flush
      if m.title
        s1 = m.title.dup
        s2 = m.title.strip
        if s1 != s2
          puts "#{m} : #{s1.inspect} -> #{s2.inspect}"
          m.update_attribute :title, s2
          sleep 3
        end
      end
    end
  end
end
