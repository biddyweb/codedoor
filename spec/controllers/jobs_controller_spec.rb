require 'spec_helper'

describe JobsController do

  before :each do
    @client = FactoryGirl.create(:client)
    @programmer = FactoryGirl.create(:programmer, :qualified)
    @empty_user = FactoryGirl.create(:user)
  end

  describe 'GET index' do
    before :each do
      @job = FactoryGirl.create(:job, client: @client, programmer: @programmer)
    end

    it 'should show jobs for client' do
      sign_in(@client.user)
      get :index
      assigns(:jobs_as_client).should eq([@job])
      assigns(:jobs_as_programmer).should eq([])
      response.should render_template('index')
    end

    it 'should show jobs for programmer' do
      sign_in(@programmer.user)
      get :index
      assigns(:jobs_as_programmer).should eq([@job])
      assigns(:jobs_as_client).should eq([])
      response.should render_template('index')
    end

    it 'should redirect if user does not have client or programmer' do
      sign_in(@empty_user)
      get :index
      response.should redirect_to(edit_user_path(@empty_user))
    end
  end

  describe 'GET new' do
    it 'should have a new job between the client and programmer' do
      sign_in(@client.user)
      get :new, programmer_id: @programmer.id
      assigns(:job).programmer.should eq(@programmer)
      assigns(:job).client.should eq(@client)
      response.should render_template('new')
    end

    it 'should not redirect if the previous job has been finished' do
      sign_in(@client.user)
      job = FactoryGirl.create(:job, client: @client, programmer: @programmer, state: 'finished')
      get :new, programmer_id: @programmer.id
      assigns(:job).programmer.should eq(@programmer)
      assigns(:job).client.should eq(@client)
      response.should render_template('new')
    end

    it 'should redirect if there is a current job between the client and freelancer' do
      sign_in(@client.user)
      job = FactoryGirl.create(:job, client: @client, programmer: @programmer, state: 'running')
      get :new, programmer_id: @programmer.id
      response.should redirect_to(edit_job_path(job.id))
    end

    it 'should redirect if you are not a client' do
      sign_in(@programmer.user)
      get :new, programmer_id: @programmer.id
      response.should redirect_to(new_user_client_path(@programmer.user))
    end
  end

  describe 'POST create' do
  end

  describe 'GET edit' do
    it 'should have an error if the job is not associated with the client or programmer' do
    end
  end

  describe 'POST create_message' do
  end

  describe 'POST start' do
  end

  describe 'POST cancel' do
  end

  describe 'POST finish' do
  end

end
