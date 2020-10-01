module Utility
    ( biject
    , concatUnzip
    , findMap
    , withTag
    , zipWithExact
    ) where

import Universum hiding (foldr)

import           Data.Aeson ((.=), Value (String), object)
import           Data.Foldable (foldr)
import qualified Data.Map.Strict as Map

biject :: (Ord v) => Map k v -> Map v k
biject = Map.fromList . fmap swap . Map.toList

concatUnzip :: [([a], [b])] -> ([a], [b])
concatUnzip = bimap concat concat . unzip

findMap :: (Foldable t) => (a -> Maybe b) -> t a -> Maybe b
findMap f = foldr go Nothing
  where
    go x Nothing = f x
    go _ found   = found

withTag :: Text -> [(Text, Value)] -> Value
withTag tag fields = object ("tag" .= String tag : fields)

zipWithExact :: (a -> b -> c) -> [a] -> [b] -> Maybe [c]
zipWithExact f = (fmap reverse .) . go []
  where
    go cs (a : as) (b : bs) = go (f a b : cs) as bs
    go cs []       []       = Just cs
    go _  _        _        = Nothing