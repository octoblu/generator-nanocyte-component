require 'coffee-errors'

util = require 'util'
path = require 'path'
url = require 'url'
GitHubApi = require 'github'
yeoman = require 'yeoman-generator'

extractGeneratorName = (_, appname) ->
  slugged = _.slugify appname
  match = slugged.match /^nanocyte-component-(.+)/
  return match[1].toLowerCase() if match and match.length is 2
  slugged

githubUserInfo = (name, cb) ->
  github = new GitHubApi version: '3.0.0'
  github.user.getFrom user: name, cb

class NanocyteComponentGenerator extends yeoman.generators.Base
  constructor: (args, options, config) ->
    super
    @currentYear = (new Date()).getFullYear()
    {@realname, @githubUrl} = options
    @on 'end', => @installDependencies skipInstall: options['skip-install']
    @pkg = JSON.parse @readFileAsString path.join __dirname, '../package.json'

  askFor: ->
    # have Yeoman greet the user.
    console.log @yeoman

    done = @async()
    componentName = extractGeneratorName @_, @appname

    prompts = [
      name: 'githubUser'
      message: 'Would you mind telling me your organization/username on GitHub?'
      default: 'octoblu'
    ,
      name: 'componentName'
      message: 'What\'s the base name of your component? (We\'ll add the "nanocyte-component-")'
      default: componentName
    ]

    @prompt prompts, (props) =>
      @githubUser = props.githubUser
      @componentName = props.componentName
      @appname = 'nanocyte-component-' + @componentName
      done()

  userInfo: ->
    return if @realname? and @githubUrl?

    done = @async()

    githubUserInfo @githubUser, (err, res) =>
      @realname = res.name
      @email = res.email
      @githubUrl = res.html_url
      done()

  projectfiles: ->
    @template '_package.json', 'package.json'
    @template '_travis.yml', '.travis.yml'
    @template '_index.js', 'index.js'
    @template '_component.coffee', "src/#{@_.slugify @componentName}.coffee"
    @template '_component-spec.coffee', "test/#{@_.slugify @componentName}-spec.coffee"
    @template '_mocha.opts', "test/mocha.opts"
    @template '_test_helper.coffee', "test/test_helper.coffee"
    @template 'README.md'
    @template 'LICENSE'

  gitfiles: ->
    @copy '_gitignore', '.gitignore'

  app: ->

  templates: ->

  tests: ->

module.exports = NanocyteComponentGenerator
