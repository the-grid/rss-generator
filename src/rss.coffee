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
    html = null
    if item.content?.length
      html = item.content.filter((block) ->
        block.metadata?.starred is true
      ).map (block) ->
        block.html
    feed.item
      title: item.block?.title or item.metadata?.title or item.title
      description: html or item.block?.html or item.block?.description or item.metadata?.description or ''
      url: itemUrl
      date: item.metadata?.datePublished or item.metadata?.dateModified
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

