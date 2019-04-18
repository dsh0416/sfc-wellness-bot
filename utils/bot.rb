module BOT
  class << self
    def login(conn, username, password, semester)
      resp = conn.post '/index.php', {
        login: username,
        password: password,
        submit: 'login',
        page: 'top',
        mode: 'login',
        semester: semester,
        lang: 'ja',
      }, {}

      if resp.status == 200
        doc = Nokogiri::HTML(resp.body)
        dom = doc.css('p.error')&.first
        success = dom&.children&.first&.text == 'loginしました．'
        if success
          # Return auth
          link = CGI::parse(doc.css('a.w3-hover-black')[0].attributes['href'].value)
          return link['auth'][0]
        end
      end
      puts dom&.children&.first&.text
      raise 'Unable to Login'
    end

    def register(conn, auth, uid, lecture, semester, date)
      resp = conn.post '/index.php', {
        auth: auth,
        uid: uid,
        submit: 'login',
        page: 'reserve',
        mode: 'confirm',
        lecture: lecture,
        d: date,
        semester: semester,
        lang: 'ja',
      }, {}

      if resp.status == 200
        doc = Nokogiri::HTML(resp.body)
        dom = doc.css('p.error')&.first
        success = dom&.children&.first&.text&.end_with? '予約しました．'
        if success
          return true
        else
          puts dom&.children&.first&.text
        end
      end
      return false
    end
  end
end
