namespace :db do  
  desc "reset sequences for a specific table or all tables"
  task :sequence_reset => :environment do
    sql = <<-SQL
      SELECT 'SELECT SETVAL(' ||
             quote_literal(quote_ident(PGT.schemaname) || '.' || quote_ident(S.relname)) ||
             ', COALESCE(MAX(' ||quote_ident(C.attname)|| '), 1) ) FROM ' ||
             quote_ident(PGT.schemaname)|| '.'||quote_ident(T.relname)|| ';' as query
      FROM pg_class AS S,
           pg_depend AS D,
           pg_class AS T,
           pg_attribute AS C,
           pg_tables AS PGT
      WHERE S.relkind = 'S'
          AND S.oid = D.objid
          AND D.refobjid = T.oid
          AND D.refobjid = C.attrelid
          AND D.refobjsubid = C.attnum
          AND T.relname = PGT.tablename
      ORDER BY S.relname;
    SQL

    ActiveRecord::Base.connection.execute(sql).each do |query|
      ActiveRecord::Base.connection.execute(query['query'])
    end
  end
end  