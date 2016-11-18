-- Copyright (C) 2016 Pau Carré Cardona - All Rights Reserved
-- You may use, distribute and modify this code under the
-- terms of the Apache License v2.0 (http://www.apache.org/licenses/LICENSE-2.0.txt).

local libs = io.popen("realpath $(dirname " .. arg[0] .. ")/.."):read()
package.path = package.path .. ';' ..
  libs .. '/0-tiefvision-commons/?.lua;' ..
  libs .. '/5-train-classification/?.lua;' ..
  libs .. '/8-similarity-db-cnn/?.lua'

require 'inn'
require 'optim'
require 'torch'
require 'xlua'
require 'lfs'
require 'image'
local tiefvision_commons = require 'tiefvision_commons'
local similarity_db_lib = require 'similarity_db_lib'

function createDb(sourceFolder, destinationFolder)
  local files = tiefvision_commons.getFiles(sourceFolder)
  local encoder = similarity_db_lib.getEncoder()
  for fileIndex = 1, #files do
    local file = files[fileIndex]
    local destPath = destinationFolder .. '/' .. file
    if(not tiefvision_commons.fileExists(destPath)) then
      print('Encoding ' .. file)
      local encoderOutput = similarity_db_lib.encodeImage(sourceFolder .. '/' .. file, encoder)
      torch.save(destPath, encoderOutput)
      collectgarbage()
    end
  end
end

createDb(tiefvision_commons.resourcePath('dresses-db/bboxes/1'), tiefvision_commons.dataPath('encoded-images'))
createDb(tiefvision_commons.resourcePath('dresses-db/bboxes-flipped/1'), tiefvision_commons.dataPath('encoded-images-flipped'))
