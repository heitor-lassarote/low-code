module Config where

import Universum

import Options.Applicative

data DBConfig = DBConfig
    { dbHost        :: Text
    , dbName        :: Text
    , dbPassword    :: Text
    , dbPort        :: Int
    , dbUser        :: Text
    }

parseDBConfig :: Parser DBConfig
parseDBConfig = DBConfig
    <$> strOption
        (  long "dbhost"
        <> short 'H'
        <> metavar "ADDRESS"
        <> help "Host address for the database" )
    <*> strOption
        (  long "dbname"
        <> short 'N'
        <> metavar "DB_NAME"
        <> help "The name of the database" )
    <*> strOption
        (  long "dbpassword"
        <> short 'W'
        <> metavar "PASSWORD"
        <> help "The password to connect to the database" )
    <*> option auto
        (  long "dbport"
        <> short 'D'
        <> metavar "DB_PORT"
        <> help "Port to connect to the database" )
    <*> strOption
        (  long "dbuser"
        <> short 'U'
        <> metavar "USERNAME"
        <> help "The username to connect to the database" )

data ServerConfig = ServerConfig
    { dbConfig                     :: DBConfig
    , serverConnections            :: Int
    , serverDetailedRequestLogging :: Bool
    , serverIpFromHeader           :: Bool
    , serverPort                   :: Int
    }

parseServerConfig :: Parser ServerConfig
parseServerConfig = ServerConfig
    <$> parseDBConfig
    <*> option auto
        (  long "connections"
        <> short 'c'
        <> metavar "CONNECTION_POOL_COUNT"
        <> help "Number of connections to keep open in the pool" )
    <*> switch
        (  long "ip-from-header"
        <> short 'i'
        <> help "Get the IP address from the header when logging. Useful when sitting behind a reverse proxy." )
    <*> switch
        (  long "detailed-request-logging"
        <> short 'l'
        <> help "Use detailed request logging system." )
    <*> option auto
        (  long "port"
        <> short 'p'
        <> metavar "PORT"
        <> help "Port to connect to server" )