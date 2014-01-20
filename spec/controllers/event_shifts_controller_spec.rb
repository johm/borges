require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe EventShiftsController do

  # This should return the minimal set of attributes required to create a valid
  # EventShift. As you add validations to EventShift, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "event_staffer" => "" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # EventShiftsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all event_shifts as @event_shifts" do
      event_shift = EventShift.create! valid_attributes
      get :index, {}, valid_session
      assigns(:event_shifts).should eq([event_shift])
    end
  end

  describe "GET show" do
    it "assigns the requested event_shift as @event_shift" do
      event_shift = EventShift.create! valid_attributes
      get :show, {:id => event_shift.to_param}, valid_session
      assigns(:event_shift).should eq(event_shift)
    end
  end

  describe "GET new" do
    it "assigns a new event_shift as @event_shift" do
      get :new, {}, valid_session
      assigns(:event_shift).should be_a_new(EventShift)
    end
  end

  describe "GET edit" do
    it "assigns the requested event_shift as @event_shift" do
      event_shift = EventShift.create! valid_attributes
      get :edit, {:id => event_shift.to_param}, valid_session
      assigns(:event_shift).should eq(event_shift)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new EventShift" do
        expect {
          post :create, {:event_shift => valid_attributes}, valid_session
        }.to change(EventShift, :count).by(1)
      end

      it "assigns a newly created event_shift as @event_shift" do
        post :create, {:event_shift => valid_attributes}, valid_session
        assigns(:event_shift).should be_a(EventShift)
        assigns(:event_shift).should be_persisted
      end

      it "redirects to the created event_shift" do
        post :create, {:event_shift => valid_attributes}, valid_session
        response.should redirect_to(EventShift.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved event_shift as @event_shift" do
        # Trigger the behavior that occurs when invalid params are submitted
        EventShift.any_instance.stub(:save).and_return(false)
        post :create, {:event_shift => { "event_staffer" => "invalid value" }}, valid_session
        assigns(:event_shift).should be_a_new(EventShift)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        EventShift.any_instance.stub(:save).and_return(false)
        post :create, {:event_shift => { "event_staffer" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested event_shift" do
        event_shift = EventShift.create! valid_attributes
        # Assuming there are no other event_shifts in the database, this
        # specifies that the EventShift created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        EventShift.any_instance.should_receive(:update_attributes).with({ "event_staffer" => "" })
        put :update, {:id => event_shift.to_param, :event_shift => { "event_staffer" => "" }}, valid_session
      end

      it "assigns the requested event_shift as @event_shift" do
        event_shift = EventShift.create! valid_attributes
        put :update, {:id => event_shift.to_param, :event_shift => valid_attributes}, valid_session
        assigns(:event_shift).should eq(event_shift)
      end

      it "redirects to the event_shift" do
        event_shift = EventShift.create! valid_attributes
        put :update, {:id => event_shift.to_param, :event_shift => valid_attributes}, valid_session
        response.should redirect_to(event_shift)
      end
    end

    describe "with invalid params" do
      it "assigns the event_shift as @event_shift" do
        event_shift = EventShift.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        EventShift.any_instance.stub(:save).and_return(false)
        put :update, {:id => event_shift.to_param, :event_shift => { "event_staffer" => "invalid value" }}, valid_session
        assigns(:event_shift).should eq(event_shift)
      end

      it "re-renders the 'edit' template" do
        event_shift = EventShift.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        EventShift.any_instance.stub(:save).and_return(false)
        put :update, {:id => event_shift.to_param, :event_shift => { "event_staffer" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested event_shift" do
      event_shift = EventShift.create! valid_attributes
      expect {
        delete :destroy, {:id => event_shift.to_param}, valid_session
      }.to change(EventShift, :count).by(-1)
    end

    it "redirects to the event_shifts list" do
      event_shift = EventShift.create! valid_attributes
      delete :destroy, {:id => event_shift.to_param}, valid_session
      response.should redirect_to(event_shifts_url)
    end
  end

end
