def db_connection
  begin
    connection = PG.connect(dbname: 'urls')

    yield (connection)

  ensure
    connection.close
  end
end

def load_urls
  sql = ('SELECT urls.site_name, urls.shortened, urls.url
          FROM urls
          ORDER BY created_at DESC
          LIMIT 15')
  urls = db_connection do |conn|
           conn.exec(sql)
         end
  urls.to_a
end

def make_site_name(url)
  url.slice!("https://")
  url.slice!("http://")
  url.slice!("www.")
  url = url.split("/").first.capitalize!
end

def post_url(url, shrunken)
  site_name = make_site_name(url)
  sql = 'INSERT INTO urls (url, site_name, shortened, created_at)
         VALUES ($1, $2, $3, NOW())'
  db_connection do |conn|
    conn.exec_params(sql, [url, site_name, shrunken])
  end
end

def locate_url(page_id) # TODO rename this
  sql = "SELECT urls.url FROM urls WHERE urls.shortened = '#{page_id}'"
  url_shortened = db_connection do |conn|
                    conn.exec(sql)
                  end
  url_shortened.to_a
end

def already_used?(num)
  sql = "SELECT urls.shortened FROM urls WHERE urls.shortened = '#{num}'"
  duplicate = db_connection do |conn|
    dup = conn.exec(sql).to_a.first
    if dup != nil
      dup = dup["shortened"]
    end
    return dup
  end
  if duplicate == num
    return true
  else
    return false
  end
end

def generate_short_url
  url = ""
  4.times do
    url += rand(97..122).chr
  end
  url
end

def assign_short_url
  short = generate_short_url
  while already_used?(short) # FIXME how to prevent this from entering an infinite loop?
    short = generate_short_url
  end
  short
end
