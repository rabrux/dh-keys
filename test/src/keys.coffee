# packages
Keys   = require '../../dist'
fs     = require 'fs'
path   = require 'path'
should = require( 'chai' ).should()

describe 'helper Keys', ->

  it 'helper exists', ( done ) ->
    should.exist Keys
    done()

  it 'create new instance', ( done ) ->
    key = new Keys()
    ( key instanceof Keys ).should.be.equal true
    done()

  it 'from abstract method exists', ( done ) ->
    should.exist Keys.from
    done()

  it 'load public key from string', ( done ) ->
    pk = "-----BEGIN PUBLIC KEY-----\nMFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAK3Uu60E7oM8ON62X9QVvUqRK6oy3h8Z\nUhuALFKRd2538+IPt9paZCCRNreJpzCAogh1kXU77KJ6id/aLriBKf0CAwEAAQ==\n-----END PUBLIC KEY-----"
    key = Keys.from pk
    ( key instanceof Keys and key.isPublic() ).should.be.equal true
    done()

  it 'load private key from string', ( done ) ->
    pk = "-----BEGIN RSA PRIVATE KEY-----\nMIIBOwIBAAJBAK3Uu60E7oM8ON62X9QVvUqRK6oy3h8ZUhuALFKRd2538+IPt9pa\nZCCRNreJpzCAogh1kXU77KJ6id/aLriBKf0CAwEAAQJBAIKsctDj7jC1asLxMiSK\nmxuc+cgeKSATtsd5mNgRBkkBn86p7Gig3Ntq5xg7+HkxGLWsgvaceW+GmvuB50nR\nTYECIQDuQyL5PQb2EOVgoVjB3T69RUtTErPqrLQmP1t7124ZkQIhALrFphx03xZ9\n9VcYE7Bjzfm4XF0cH+UMRk7/QpWC4jOtAiEArtcdZwBdh1xGtm4wD7MnQwUCjWeA\nF4m8eQStQWeJJ8ECIGQv78ol+yFikb+VX8Jn1y6UcZ9UndtM+U4Y6UuwOMzFAiBa\n7sUq0adxuLH+MrIpb7NSdYz/iIvVs2U8+DNP3VDPtA==\n-----END RSA PRIVATE KEY-----"
    key = Keys.from pk, 'private'
    ( key instanceof Keys and key.isPrivate() instanceof Object ).should.be.equal true
    done()

  it 'save method exists', ( done ) ->
    key = new Keys b : 512
    should.exist key.save
    done()

  it 'export key to json file throws', ( done ) ->
    key = new Keys b : 512
    ( () -> key.save path.join process.cwd(), 'lorem', '.keys' ).should.throw Error, 'inaccessible file path'
    done()

  it 'export key to json file', ( done ) ->
    key = new Keys b : 512
    ( key.save path.join process.cwd(), '.keys' ).should.be.equal true
    done()

  it 'load abstract method exists', ( done ) ->
    should.exist Keys.load
    done()

  it 'load key fron json file throws because path is not a file', ( done ) ->
    ( () -> key = Keys.load path.join process.cwd(), 'test' ).should.throw Error, 'path is a directory'
    done()

  it 'load key fron json file throws inaccessible file path', ( done ) ->
    ( () -> key = Keys.load path.join process.cwd(), 'lorem', '.keys' ).should.throw Error, 'inaccessible file path'
    done()

  it 'load key from json file throws invalid json keys file', ( done ) ->
    ( () -> key = Keys.load path.join process.cwd(), 'Gulpfile.coffee' ).should.throw Error, 'invalid json keys file'
    done()

  it 'load keys from json file throws invalid keys file format', ( done ) ->
    ( () -> key = Keys.load path.join process.cwd(), 'package.json' ).should.throw Error, 'invalid keys file format'
    done()

  it 'load keys from json file throws invalid keys file format', ( done ) ->
    ( () -> key = Keys.load path.join process.cwd(), 'lorem.keys' ).should.throw Error, 'invalid keys file format'
    done()

  it 'load key from json file', ( done ) ->
    key = Keys.load path.join process.cwd(), '.keys'
    ( key instanceof Keys ).should.be.equal true
    done()

  it 'remove key file', ( done ) ->
    fs.unlinkSync path.join( process.cwd(), '.keys' )
    done()

