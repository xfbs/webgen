# -*- encoding: utf-8 -*-

require 'minitest/autorun'
require 'helper'
require 'ostruct'
require 'webgen/content_processor/erubis'
require 'webgen/context'

class TestErubis < MiniTest::Unit::TestCase

  include Test::WebgenAssertions

  def test_static_call
    website = MiniTest::Mock.new
    website.expect(:ext, OpenStruct.new)
    website.expect(:config, {'contentprocessor.erubis.options' => {}, 'contentprocessor.erubis.use_pi' => false})
    node = MiniTest::Mock.new
    node.expect(:alcn, '/test')

    context = Webgen::Context.new(website, :chain => [node], :doit => 'hallo')
    cp = Webgen::ContentProcessor::Erubis

    context.content = "<%= context[:doit] %>6\n<%= context.ref_node.alcn %>\n<%= context.node.alcn %>\n<%= context.dest_node.alcn %><% context.website %>"
    assert_equal("hallo6\n/test\n/test\n/test", cp.call(context).content)

    context.content = "\n<%= 5* %>"
    assert_error_on_line(SyntaxError, 2) { cp.call(context) }

    context.content = "\n\n<% unknown %>"
    assert_error_on_line(NameError, 3) { cp.call(context) }

    website.config['contentprocessor.erubis.options'][:trim] = true
    context.content = "<% for i in [1] %>\n<%= i %>\n<% end %>"
    assert_equal("1\n", cp.call(context).content)

    website.config['contentprocessor.erubis.use_pi'] = true
    context.content = "<?rb for i in [1] ?>\n@{i}@\n<?rb end ?>"
    assert_equal("1\n", cp.call(context).content)
  end

end
