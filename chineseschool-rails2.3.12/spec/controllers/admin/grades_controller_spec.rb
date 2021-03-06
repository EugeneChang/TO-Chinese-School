require 'spec_helper'

describe Admin::GradesController, 'displaying index' do
  before(:each) do
    stub_check_authentication_and_authorization_in @controller
    @fake_grades = []
  end

  it 'should find all grades' do
    Grade.expects(:find).with(:all).once.returns(@fake_grades)
    get :index
  end

  it 'should assign grades found' do
    Grade.expects(:find).with(:all).once.returns(@fake_grades)
    get :index
    assigns[:grades].should == @fake_grades
  end
  
  it 'should be success' do
    get :index
    response.should be_success
  end
  
  it 'should render index template' do
    get :index
    response.should render_template('admin/grades/index.html.erb')
  end

  it 'should respond to correct route' do
    { :get => '/chineseschool/admin/grades' }.should route_to( :controller => 'admin/grades', :action => 'index' )
  end
end
