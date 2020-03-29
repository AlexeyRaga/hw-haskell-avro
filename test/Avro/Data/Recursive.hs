{-# LANGUAGE DeriveAnyClass      #-}
{-# LANGUAGE DeriveFoldable      #-}
{-# LANGUAGE DeriveFunctor       #-}
{-# LANGUAGE DeriveGeneric       #-}
{-# LANGUAGE DeriveTraversable   #-}
{-# LANGUAGE NumDecimals         #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE QuasiQuotes         #-}
{-# LANGUAGE RankNTypes          #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE StandaloneDeriving  #-}
{-# LANGUAGE StrictData          #-}
{-# LANGUAGE TemplateHaskell     #-}
{-# LANGUAGE TupleSections       #-}
{-# LANGUAGE TypeApplications    #-}
module Avro.Data.Recursive
where

import Data.Avro.Internal.Time (microsToDiffTime, microsToUTCTime, millisToDiffTime, millisToUTCTime)

import Data.Avro.Deriving (deriveAvroFromByteString, r)

import Hedgehog
import Hedgehog.Gen   as Gen
import Hedgehog.Range as Range

deriveAvroFromByteString [r|
{
  "type": "record",
  "name": "Recursive",
  "fields": [
    { "name": "index", "type": "int" },
    { "name": "tag", "type": ["null", "Recursive"] }
  ]
}
|]

recursiveGen :: MonadGen m => m Recursive
recursiveGen = Recursive
  <$> Gen.int32 Range.linearBounded
  <*> Gen.maybe recursiveGen

-- maybeTestGen :: MonadGen m => m MaybeTest
-- maybeTestGen = MaybeTest
--   <$> Gen.maybe (Gen.text (Range.linear 0 50) Gen.alphaNum)
--   <*> (FixedTag <$> Gen.bytes (Range.singleton 3))
--   <*> Gen.bytes (Range.linear 0 30)
