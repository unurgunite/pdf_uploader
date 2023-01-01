# frozen_string_literal: true

require 'dotenv/load'
require 'telegram/bot'
require 'nokogiri'
require 'httparty'
require 'delegate'
require_relative '../pdf_uploader/url'
require_relative '../pdf_uploader/parser'
