RSS = require 'rss'

exports.solveRss = (data, callback) ->
  unless data.items?.length
    err = new Error 'No items found'
    err.site = data.site
    err.path = data.path
    err.style = data.style
    err.job = data.job or null
    err.options = data.options or null
    return callback err

  feed = new RSS
    title: data.title
    pubDate: data.updated_at
    generator: 'The Grid'
    feed_url: "#{data.siteUrl}#{data.path}"
    site_url: data.siteUrl

  for item in data.items
    if item.metadata?.url
      itemUrl = "#{data.siteUrl}#{item.metadata.url}"
    else
      itemUrl = item.metadata?.isBasedOnUrl or ''
    feed.item
      title: item.block?.title or item.metadata?.title or item.title
      description: item.block?.html or item.block?.description or item.metadata?.description or ''
      url: itemUrl
      date: item.metadata?.datePublished
      guid: item.id

  result =
    path: data.path
    site: data.site
    page: data.id
    style: data.style
    html: feed.xml
      indent: true
    solution: {}
    staging: data.staging or false
    job: data.job or null
    options: data.options or null
    gss: ''
    css: ''
    format: data.format
  callback null, result

