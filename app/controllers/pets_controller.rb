class PetsController < ApplicationController

  get '/pets' do
    @pets = Pet.all
    erb :'/pets/index'
  end

  get '/pets/new' do
    @owners = Owner.all
    @pet_name = Pet.find_by_name(params[:pet_name])
    erb :'/pets/new'
  end

  post '/pets' do

    @pet = Pet.create(:name => params["pet_name"])


    if params["owner_name"].empty?
      @pet.owner = Owner.find(params["owner_id"])
      @pet.save
    else
      if Owner.find_by_name(params["owner_name"]).nil?
        @pet.owner = Owner.create(name: params["owner_name"])
        @pet.save
      else
        @pet.owner = Owner.find_by_name(params["owner_name"])
        @pet.save
      end
    end
    redirect to "pets/#{@pet.id}"
  end

  get '/pets/:id' do
    @pet = Pet.find(params[:id])
    if !@pet.owner.nil?
      @owner_name = @pet.owner.name
    else
      @owner_name = "No owner"
    end
    erb :'/pets/show'
  end

  patch '/pets/:id' do
    @pet = Pet.find(params["id"])
    @pet.name = params["pet_name"]
    @pet.save
    entered_name = params["owner"]["name"]
    if entered_name.empty?
      @pet.owner = Owner.find(params["owner_id"])
      @pet.save
    else
      if Owner.find_by_name(entered_name).nil?
        @pet.owner = Owner.create(name: entered_name)
        @pet.save
      else
        @pet.owner = Owner.find_by_name(entered_name)
        @pet.save
      end
    end
    @owner = @pet.owner
    redirect to "pets/#{@pet.id}"
  end

  get '/pets/:id/edit' do
    @pet = Pet.find(params[:id])
    @owners = Owner.all
    erb :'/pets/edit'
  end
end
