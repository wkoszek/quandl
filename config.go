package main

// Config has all the elements required for the DB connection
type Config struct {
	dbStr      string
	listenAddr string
	baseURL    string
}

func configGetDev() *Config {
	return &Config{
		dbStr:      "user=wk host=localhost sslmode=disable",
		listenAddr: ":8080",
		baseURL:    "http://goweb1.dev/",
	}
}

func configGetProd() *Config {
	return &Config{
		dbStr:      "user=ubuntu dbname=ubuntu password=ubuntu host=172.17.0.1 sslmode=disable",
		listenAddr: ":8080",
		baseURL:    "https://wordmogul.com/",
	}
}

// ConfigGet returns the config object
func ConfigGet() *Config {
	if isDevel {
		return configGetDev()
	}
	return configGetProd()
}
