require 'spec_helper'

describe Memrise do
  let(:fetcher) { mock_fetcher = mock('fetcher') }
  let(:memrise) { memrise = Memrise.new(fetcher) }

  describe '#find_user' do
    it 'should find existing user' do
      fetcher.should_receive(:fetch).
        with('http://www.memrise.com/api/1.0/user/?format=json&username=doriath').
        and_return('{"meta": {"limit": 20, "next": null, "offset": 0, "previous": null, "total_count": 1}, "objects": [{"id": "551020", "resource_uri": "/api/1.0/user/551020/", "username": "doriath"}]}')

      user = memrise.find_user 'doriath'

      user.should be_a(User)
      user.id.should == '551020'
      user.username.should == 'doriath'
    end

    it 'should return nil for non existing user' do
      fetcher.should_receive(:fetch).
        with('http://www.memrise.com/api/1.0/user/?format=json&username=doriath').
        and_return('{"meta": {"limit": 20, "next": null, "offset": 0, "previous": null, "total_count": 0}, "objects": [ ]}')

      user = memrise.find_user 'doriath'

      user.should be_nil
    end
  end

  describe '#find_iset' do
    it 'should return existing iset' do
      fetcher.should_receive(:fetch).
        with('http://www.memrise.com/api/1.0/iset/?format=json&slug=technical-english-380-words').
        and_return('{"meta": {"limit": 20, "next": null, "offset": 0, "previous": null, "total_count": 1}, "objects": [{"author": "/api/1.0/user/347943/", "cre": "2012-04-01T11:40:29", "description": "engineering", "featured": false, "featured_order": null, "id": "10020337", "name": "Technical English 380 words", "photo": null, "photo_absolute_url": "http://static.memrise.com/img/hanborough/default-iset-photo.png", "photo_iphonized_asset": "static-memrise-com--img--hanborough--default-iset-photo.png", "resource_uri": "/api/1.0/iset/10020337/", "slug": "technical-english-380-words", "staff_edit_only": false, "status": 1, "topic": "/api/1.0/topic/495/"}]}')

      iset = memrise.find_iset('technical-english-380-words')
      iset.should be_a(Iset)
      iset.id.should == '10020337'
    end

    it 'should return nil for non existing iset' do
      fetcher.should_receive(:fetch).
        with('http://www.memrise.com/api/1.0/iset/?format=json&slug=technical-english-380-words').
        and_return('{"meta": {"limit": 20, "next": null, "offset": 0, "previous": null, "total_count": 0}, "objects": []}')

      iset = memrise.find_iset('technical-english-380-words')
      iset.should be_nil
    end
  end

  describe '#get_items_for' do
    it 'should return all items' do
      fetcher.should_receive(:fetch).
        with('http://www.memrise.com/api/1.0/itemiset/?format=json&iset=10020337').
        and_return('{"meta": {"limit": 20, "next": null, "offset": 0, "previous": null, "total_count": 2}, "objects": [{"cre": "2012-04-03T09:44:25", "id": "2216100", "iset": "/api/1.0/iset/10020337/", "item": {"author": "/api/1.0/user/347943/", "cre": "2012-04-03T09:44:24", "defn": "zastapic", "gender": null, "id": "1425747", "moderation_dt": null, "moderation_status": null, "moderation_user": null, "part_of_speech": null, "pronunciation": null, "resource_uri": "/api/1.0/item/1425747/", "special_properties": null, "word": "supersede"}, "order": 2.0, "resource_uri": "/api/1.0/itemiset/2216100/"}, {"cre": "2012-04-03T09:56:15", "id": "2216236", "iset": "/api/1.0/iset/10020337/", "item": {"author": "/api/1.0/user/273973/", "cre": "2012-03-15T11:13:02", "defn": "budzet", "gender": null, "id": "1297386", "moderation_dt": null, "moderation_status": null, "moderation_user": null, "part_of_speech": null, "pronunciation": null, "resource_uri": "/api/1.0/item/1297386/", "special_properties": null, "word": "budget"}, "order": 3.0, "resource_uri": "/api/1.0/itemiset/2216236/"}]}')

      items = memrise.get_items_for('10020337')
      items.should have(2).items
      items[0].word.should == 'supersede'
      items[0].definition.should == 'zastapic'
      items[1].word.should == 'budget'
      items[1].definition.should == 'budzet'
    end

    it 'should handle pagination' do
      fetcher.should_receive(:fetch).
        with('http://www.memrise.com/api/1.0/itemiset/?format=json&iset=10020337').
        and_return('{"meta": {"limit": 20, "next": "/api/1.0/itemiset/?format=json&limit=20&offset=20", "offset": 0, "previous": null, "total_count": 100}, "objects": [{"cre": "2012-04-03T09:44:25", "id": "2216100", "iset": "/api/1.0/iset/10020337/", "item": {"author": "/api/1.0/user/347943/", "cre": "2012-04-03T09:44:24", "defn": "zastapic", "gender": null, "id": "1425747", "moderation_dt": null, "moderation_status": null, "moderation_user": null, "part_of_speech": null, "pronunciation": null, "resource_uri": "/api/1.0/item/1425747/", "special_properties": null, "word": "supersede"}, "order": 2.0, "resource_uri": "/api/1.0/itemiset/2216100/"}, {"cre": "2012-04-03T09:56:15", "id": "2216236", "iset": "/api/1.0/iset/10020337/", "item": {"author": "/api/1.0/user/273973/", "cre": "2012-03-15T11:13:02", "defn": "budzet", "gender": null, "id": "1297386", "moderation_dt": null, "moderation_status": null, "moderation_user": null, "part_of_speech": null, "pronunciation": null, "resource_uri": "/api/1.0/item/1297386/", "special_properties": null, "word": "budget"}, "order": 3.0, "resource_uri": "/api/1.0/itemiset/2216236/"}]}')
      fetcher.should_receive(:fetch).
        with('http://www.memrise.com/api/1.0/itemiset/?format=json&limit=100&iset=10020337').
        and_return('{"meta": {"limit": 20, "next": null, "offset": 0, "previous": null, "total_count": 40}, "objects": [{"cre": "2012-04-03T09:44:25", "id": "2216100", "iset": "/api/1.0/iset/10020337/", "item": {"author": "/api/1.0/user/347943/", "cre": "2012-04-03T09:44:24", "defn": "zastapic", "gender": null, "id": "1425747", "moderation_dt": null, "moderation_status": null, "moderation_user": null, "part_of_speech": null, "pronunciation": null, "resource_uri": "/api/1.0/item/1425747/", "special_properties": null, "word": "supersede"}, "order": 2.0, "resource_uri": "/api/1.0/itemiset/2216100/"}, {"cre": "2012-04-03T09:56:15", "id": "2216236", "iset": "/api/1.0/iset/10020337/", "item": {"author": "/api/1.0/user/273973/", "cre": "2012-03-15T11:13:02", "defn": "budzet", "gender": null, "id": "1297386", "moderation_dt": null, "moderation_status": null, "moderation_user": null, "part_of_speech": null, "pronunciation": null, "resource_uri": "/api/1.0/item/1297386/", "special_properties": null, "word": "budget"}, "order": 3.0, "resource_uri": "/api/1.0/itemiset/2216236/"}]}')

      items = memrise.get_items_for('10020337')
      items.should have(2).items
    end
  end
end
