class FakeAPI

  def fetch_mentions
    # sends a HTTP request and returns a JSON response
    # "[{},{}]"
    '[{"created_at": "Wed Dec 10 13:44:39 +0000 2014", "id": 542676269176193000,"id_str": "542676269176193024", "text": "#Durst @micbote http://t.co/SRCatB4oqd"},{"created_at": "Tue Dec 09 16:18:19 +0000 2014","id": 542352552063692800,"id_str": "542352552063692800","text": "#Ende (traurig) @micbote http://t.co/oGvSTs9tvo"}]'
  end

  def fetch_mentions2


  end

end