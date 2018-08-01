# packages
fs  = require 'fs'
RSA = require 'node-rsa'

class Keys extends RSA

  @from : ( key, format = 'public' ) ->
    k = new @()
    k.importKey key, format
    k

  @load : ( filename ) ->
    it = @
    try
      data = fs.readFileSync filename
      Keys.fromJSON data.toString()
    catch e
      return Keys._error e

  save : ( filename ) ->
    try
      fs.writeFileSync filename, @toJSON()
      return true
    catch e
      return Keys._error e

  @fromJSON : ( data ) ->
    try
      jkeys = JSON.parse data
    catch e
      return throw new Error 'invalid json keys file'

    # invalid keys file
    return throw new Error 'invalid keys file format' if not jkeys.private or not jkeys.public

    try
      k = new @()
      k.importKey jkeys.private if jkeys.private
      k.importKey jkeys.public, 'public' if jkeys.public
    catch e
      return throw new Error 'invalid keys file format'

    k

  toJSON : ->
    keys =
      private : @exportKey 'private'
      public  : @exportKey 'public'

    JSON.stringify keys, null, 2

  @_error : ( e ) ->
    switch e.code
      when 'ENOENT'
        return throw new Error 'inaccessible file path'
      when 'EISDIR'
        return throw new Error 'path is a directory'
      else
        return throw new Error e

module.exports = Keys

