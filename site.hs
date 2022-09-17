--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}

import           Data.Monoid ((<>))
import           Hakyll
import           Text.Pandoc.Definition
import           Text.Pandoc.Options
import qualified Data.Text              as T

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.rst", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "posts/*"  $ do
        route $ setExtension "html"
        compile $ myCompiler
                 >>= loadAndApplyTemplate "templates/post.html"    postCtx
                 >>= loadAndApplyTemplate "templates/default.html" postCtx
                 >>= relativizeUrls

    create ["archive.html"] (usingArchivePage "Archive")

    create ["error.html"] (usingArchivePage "404 - You probably took a wrong turn somewhere")

    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) <>
                    constField "title" ""                    <>
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler

    match "keybase.txt" $ do
         route   idRoute
         compile copyFileCompiler

    where
        -- Create a page from the `archive.html` page
        usingArchivePage title = do
            route idRoute
            compile $ do
                posts <- recentFirst =<< loadAll "posts/*"
                let archiveCtx =
                        listField "posts" postCtx (return posts) <>
                        constField "title" title                 <>
                        defaultContext

                makeItem ""
                    >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                    >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                    >>= relativizeUrls


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" <>
    defaultContext

myCompiler :: Compiler (Item String)
myCompiler =
  pandocCompilerWithTransform
        defaultHakyllReaderOptions
        defaultHakyllWriterOptions
        myTransform

myTransform :: Pandoc -> Pandoc
myTransform p@(Pandoc meta blocks) = (Pandoc meta (ert:blocks))
  where
    ert = Para [ SmallCaps [Str "[ERT: ", Str $ timeEstimateString p <> "]"] ]

    timeEstimateString :: Pandoc -> T.Text
    timeEstimateString = toClockString . timeEstimateSeconds

    toClockString :: Int -> T.Text
    toClockString i
        | i >= 60 * 60 = T.pack (show hours   ++ "h" ++ show minutes ++ "m" ++ show seconds ++ "s")
        | i >= 60      = T.pack (show minutes ++ "m" ++ show seconds ++ "s")
        | otherwise    = T.pack (show seconds ++ "s")
      where
        hours   = i `quot` (60 * 60)
        minutes = (i `rem` (60 * 60)) `quot` 60
        seconds = i `rem` 60

    timeEstimateSeconds :: Pandoc -> Int
    timeEstimateSeconds = (`quot` 5) . nrWords

    nrWords :: Pandoc -> Int
    nrWords = (`quot` 5) . nrLetters

    nrLetters :: Pandoc -> Int
    nrLetters (Pandoc _ bs) = sum $ map cb bs
      where
        cbs = sum . map cb
        cbss = sum . map cbs
        cbsss = sum . map cbss

        cb :: Block -> Int
        cb (Plain is) = cis is
        cb (Para is) = cis is
        cb (CodeBlock _ s) = T.length s
        cb (RawBlock _ s) = T.length s
        cb (BlockQuote bs) = cbs bs
        cb (OrderedList _ bss) = cbss bss
        cb (BulletList bss) = cbss bss
        cb (DefinitionList ls) = sum $ map (\(is, bss) -> cis is + cbss bss) ls
        cb (Header _ _ is) = cis is
        cb HorizontalRule = 0
        cb (Table is _ _ tc tcs) = cis is + cbss tc + cbsss tcs
        cb (Div _ bs) = cbs bs
        cb Null = 0

        cis = sum . map ci
        ciss = sum . map cis

        ci :: Inline -> Int
        ci (Str s) = T.length s
        ci (Emph is) = cis is
        ci (Strong is) = cis is
        ci (Strikeout is) = cis is
        ci (Superscript is) = cis is
        ci (Subscript is) = cis is
        ci (SmallCaps is) = cis is
        ci (Quoted _ is) = cis is
        ci (Cite _ is) = cis is
        ci (Code _ s) = T.length s
        ci Space = 1
        ci SoftBreak = 1
        ci LineBreak = 1
        ci (Math _ s) = T.length s
        ci (RawInline _ s) = T.length s
        ci (Link _ is (_, s)) = cis is + T.length s
        ci (Image _ is (_, s)) = cis is + T.length s
        ci (Note bs) = cbs bs
