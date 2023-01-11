# If a particular configuration value is required but not set, it's appropriate to raise an error.
Dotenv.require_keys("DB_HOST", "DB_USER", "DB_PASSWORD", "DB_NAME")
