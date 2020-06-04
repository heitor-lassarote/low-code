module Language.Common where

import Universum

import Data.Aeson

type Variable varType = (Text, varType)

data ValueType varType
    = Variable Text
    | Constant varType
    deriving (Eq, Functor, Show)

instance (FromJSON varType) => FromJSON (ValueType varType) where
    parseJSON = withObject "value type" $ \o -> do
        variable <- o .:? "variable"
        constant <- o .:? "constant"
        case (variable, constant) of
            (Nothing, Nothing) -> fail "Must provide either a variable xor a constant."
            (Nothing, Just c ) -> Constant <$> parseJSON c
            (Just v , Nothing) -> pure $ Variable v
            (Just _ , Just _ ) -> fail "Must provide either a variable xor a constant."

instance (ToJSON varType) => ToJSON (ValueType varType) where
    toJSON (Variable text) = object [ "variable" .= String text ]
    toJSON (Constant var ) = object [ "constant" .= toJSON var  ]

data Symbol
    -- Arithmetic
    = Add
    | Divide
    | Multiply
    | Negate
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
    | Not
    | Or
    deriving (Eq, Ord, Show)

instance FromJSON Symbol where
    parseJSON = withObject "Symbol" $ \o -> toSymbol <$> o .: "symbol"
      where
        toSymbol = \case
            "Add"          -> Add
            "Divide"       -> Divide
            "Multiply"     -> Multiply
            "Negate"       -> Negate
            "Subtract"     -> Subtract
            "Different"    -> Different
            "Equal"        -> Equal
            "Greater"      -> Greater
            "GreaterEqual" -> GreaterEqual
            "Less"         -> Less
            "LessEqual"    -> LessEqual
            "And"          -> And
            "Not"          -> Not
            "Or"           -> Or
            other          -> error $ "Unknown symbol '" <> other <> "'."

instance ToJSON Symbol where
    toJSON symbol = object [ "symbol" .= String (show symbol) ]
