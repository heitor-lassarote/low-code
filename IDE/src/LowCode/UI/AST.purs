module LowCode.UI.AST where

import Prelude

type Attribute =
    { key   :: String
    , value :: String
    }

type Attributes = Array Attribute

type Name = String

data AST ast
    = Tag Name Attributes (AST ast)
    | Text String
    | Script Attributes ast

derive instance eqAST :: (Eq ast) => Eq (AST ast)

