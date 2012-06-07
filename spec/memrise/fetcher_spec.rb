require 'spec_helper'

describe Fetcher do
  let(:fetcher) { Fetcher.new }

  it 'should fetch content of the site' do
    fetcher.stub_chain(:open, :read).and_return('content')
    fetcher.fetch('www.google.com').should == 'content'
  end
end
