# This document describes the API for interacting with Pet resources
class PetsController < ApplicationController

  # return a list of Pets
  #
  def index
  end

  # return a Pet
  #
  # @query_parameter [Integer] id The ID for the Pet
  # @query_parameter [Array<String>] status! [available, pending, sold] The status of the Pet
  def show
  end

end