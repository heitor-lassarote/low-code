module Language.LowCode.Logic.Module
    ( Module (..)
    , mkModule
    ) where

import Universum hiding (Type)

import           Data.Aeson
import qualified Data.Map.Strict as Map

import Language.Common (Name)
import Language.LowCode.Logic.AST (Constructor, Field, Function, Type)

data Module exprMetadata astMetadata = Module
    { adtTemplates    :: !(Map Name [Constructor Type])
    , externs         :: !(Map Name Type)
    , functions       :: ![Function exprMetadata astMetadata]
    , importedModules :: ![Name]
    , moduleName      :: !Name
    , recordTemplates :: !(Map Name [Field Type])
    } deriving (Eq, Generic, Show, ToJSON)

instance (FromJSON astMetadata) => FromJSON (Module () astMetadata) where
    parseJSON = withObject "Language.LowCode.Logic.Module.Module" \o ->
        Module <$> o .: "adtTemplates"
               <*> o .: "externs"
               <*> o .: "functions"
               <*> o .: "importedModules"
               <*> o .: "moduleName"
               <*> o .: "recordTemplates"

mkModule :: Name -> Module exprMetadata astMetadata
mkModule name = Module Map.empty Map.empty [] [] name Map.empty
