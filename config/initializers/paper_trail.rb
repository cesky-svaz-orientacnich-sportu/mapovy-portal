::ActiveRecord.use_yaml_unsafe_load = false
::ActiveRecord.yaml_column_permitted_classes = [
  ::ActiveRecord::Type::Time::Value,
  ::ActiveSupport::TimeWithZone,
  ::ActiveSupport::TimeZone,
  ::BigDecimal,
  ::Date,
  ::Symbol,
  ::Time
]
