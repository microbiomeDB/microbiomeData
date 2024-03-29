test_that('AbundanceData validation works', {
  
  testOTU_path <- testthat::test_path('testdata','testOTU.rda')
  load(testOTU_path)

  df <- testOTU

  expect_error(microbiomeData::AbundanceData(
              data = df))
  expect_error(microbiomeData::AbundanceData(
              data = df,
              recordIdColumn = c('entity.SampleID', 'test')))
  expect_error(microbiomeData::AbundanceData(
              data = df,
              recordIdColumn = c('test')))
  expect_error(microbiomeData::AbundanceData(
              data = df,
              recordIdColumn = c('entity.SampleID'),
              ancestorIdColumns = c('test')))

  df$entity.strings <- 'a'

  expect_error(microbiomeData::AbundanceData(
              data = df,
              recordIdColumn = c('entity.SampleID')))

  df$entity.strings <- .1
  names(df)[names(df) == 'entity.strings'] <- 'entity2.notstrings'

  expect_error(microbiomeData::AbundanceData(
              data = df,
              recordIdColumn = c('entity.SampleID')))

  df$entity2.notstrings <- NULL
  testing <- microbiomeData::AbundanceData(
              data = df,
              recordIdColumn = c('entity.SampleID'))

  expect_true(inherits(testing, 'AbundanceData'))
  expect_equal(slotNames(testing), c('data', 'sampleMetadata', 'recordIdColumn', 'ancestorIdColumns', 'imputeZero', 'removeEmptySamples'))
  expect_equal(nrow(testing@data), 288)
  expect_equal(ncol(testing@data), 909)
  expect_equal(testing@recordIdColumn, 'entity.SampleID')
  expect_equal(testing@ancestorIdColumns, character(0))
  expect_true(testing@imputeZero)


  sampleMetadata <- microbiomeData::SampleMetadata(
    data = df[, 'entity.SampleID', with=F],
    recordIdColumn = 'entity.SampleID'
  )

  expect_error(
    microbiomeData::AbundanceData(
      data = df,
      sampleMetadata = sampleMetadata,
      recordIdColumn = 'entity.SampleID'
    )
  )

})

test_that("getAbundances works", {

  testOTU_path <- testthat::test_path('testdata','testOTU.rda')
  load(testOTU_path)

  df <- testOTU

  testing <- microbiomeData::AbundanceData(
    data = df,
    recordIdColumn = 'entity.SampleID'
  )
  
  abundances <- getAbundances(testing)
  expect_equal(nrow(abundances), nrow(df))
  expect_equal(ncol(abundances), ncol(df))

  ## remove ids
  abundances <- getAbundances(testing, includeIds = FALSE)
  expect_equal(nrow(abundances), nrow(df))
  expect_equal(ncol(abundances), ncol(df) - 1)

  ## remove empty samples
  df <- rbind(df,df[nrow(df)+1,])
  df$entity.SampleID[nrow(df)] <- 'im.a.sample'
  testing <- microbiomeData::AbundanceData(
    data = df,
    recordIdColumn = 'entity.SampleID',
    removeEmptySamples = TRUE
  )

  abundances <- getAbundances(testing)
  expect_equal(nrow(abundances), nrow(df) -1)
  expect_equal(ncol(abundances), ncol(df))
})

test_that("pruneFeatures works", {

  testOTU_path <- testthat::test_path('testdata','testOTU.rda')
  load(testOTU_path)

  df <- testOTU
  
  testing <- microbiomeData::AbundanceData(
    data = df,
    recordIdColumn = 'entity.SampleID'
  )
  
  # pruneFeatures touched SampleMetadata, which this AbundanceData object has none. it shouldnt fail for that though.
  testing <- pruneFeatures(testing, veupathUtils::predicateFactory('proportionNonZero', 0.5))
  expect_equal(nrow(testing@data), 288)
  expect_equal(ncol(testing@data), 13)
})