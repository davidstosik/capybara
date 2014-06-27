Capybara::SpecHelper.spec '#accept_alert', :requires => [:modals] do
  before do
    @session.visit('/with_js')
  end

  it "should accept the alert" do
    @session.accept_alert do
      @session.click_link('Open alert')
    end
    expect(@session).to have_xpath("//a[@id='open-alert' and @opened='true']")
  end
  
  it "should accept the alert if the text matches" do
    @session.accept_alert 'Alert opened' do
      @session.click_link('Open alert')
    end
    expect(@session).to have_xpath("//a[@id='open-alert' and @opened='true']")
  end
  
  it "should not accept the alert if the text doesnt match" do
    expect do
      @session.accept_alert 'Incorrect Text' do
        @session.click_link('Open alert')
      end
    end.to raise_error(Capybara::ModalNotFound)
    # @session.accept_alert {}  # clear the alert so browser continues to function
  end

  it "should return the message presented" do
    message = @session.accept_alert do
      @session.click_link('Open alert')
    end
    expect(message).to eq('Alert opened')
  end

  context "with an asynchronous alert" do
    it "should accept the alert" do
      @session.accept_alert do
        @session.click_link('Open delayed alert')
      end
      expect(@session).to have_xpath("//a[@id='open-delayed-alert' and @opened='true']")
    end

    it "should return the message presented" do
      message = @session.accept_alert do
        @session.click_link('Open delayed alert')
      end
      expect(message).to eq('Delayed alert opened')
    end
    
    it "should allow to adjust the delay" do
      @session.accept_alert wait: 4 do
        @session.click_link('Open slow alert')
      end
      expect(@session).to have_xpath("//a[@id='open-slow-alert' and @opened='true']")
    end
  end
end