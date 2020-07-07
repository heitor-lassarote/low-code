module Language.Common where

import Universum

import Data.Aeson

type Name = Text

type Double2 = (Double, Double)

data ValueType varType
    = Variable Name
    | Constant varType
    deriving (Eq, Functor, Show)

instance (FromJSON varType) => FromJSON (ValueType varType) where
    parseJSON = withObject "Language.Common.ValueType" \o -> do
        variable <- o .:? "variable"
        constant <- o .:? "constant"
        case (variable, constant) of
            (Nothing, Just c ) -> Constant <$> parseJSON c
            (Just v , Nothing) -> pure $ Variable v
            _                  -> fail "Must provide either a variable xor a constant."

instance (ToJSON varType) => ToJSON (ValueType varType) where
    toJSON (Variable text) = object [ "variable" .= String text ]
    toJSON (Constant var ) = object [ "constant" .= toJSON var  ]

data BinarySymbol
    -- Arithmetic
    = Add
    | Divide
    | Multiply
    | Subtract

    -- Comparison
    | Different
    | Equal
    | Greater
    | GreaterEqual
    | Less
    | LessEqual

    -- Logical
    | And
    | Or
    deriving (Enum, Eq, Ord, Read, Show)

isArithmetic :: BinarySymbol -> Bool
isArithmetic = \case
    Add -> True
    Divide -> True
    Multiply -> True
    Subtract -> True
    _ -> False

isComparison :: BinarySymbol -> Bool
isComparison = \case
    Different -> True
    Equal -> True
    Greater -> True
    GreaterEqual -> True
    Less -> True
    LessEqual -> True
    _ -> False

isLogical :: BinarySymbol -> Bool
isLogical = \case
    And -> True
    Or -> True
    _ -> False

unknownSymbol :: (IsString s, Monoid s) => s -> s
unknownSymbol symbol = mconcat ["Unknown symbol '", symbol, "'."]

instance FromJSON BinarySymbol where
    parseJSON = withObject "Language.Common.BinarySymbol" \o -> toSymbol =<< o .: "symbol"
      where
        toSymbol sym = maybe (fail $ unknownSymbol sym) pure (readMaybe sym)

-- TODO: Perhaps change from object to text?
instance ToJSON BinarySymbol where
    toJSON symbol = object [ "symbol" .= String (show symbol) ]

data UnarySymbol
    -- Arithmetic
    = Negate

    -- Logical
    | Not
    deriving (Enum, Eq, Ord, Read, Show)

instance FromJSON UnarySymbol where
    parseJSON = withObject "Language.Common.UnarySymbol" \o -> toSymbol =<< o .: "symbol"
      where
        toSymbol sym = maybe (fail $ unknownSymbol sym) pure (readMaybe sym)

instance ToJSON UnarySymbol where
    toJSON symbol = object [ "symbol" .= String (show symbol) ]
