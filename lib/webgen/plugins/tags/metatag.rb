#
#--
#
# $Id$
#
# webgen: a template based web page generator
# Copyright (C) 2004 Thomas Leitner
#
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program; if not,
# write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#
#++
#

require 'util/ups'
require 'webgen/plugins/tags/tags'

module Tags

  class MetaTag < UPS::Plugin

    NAME = "Meta tag"
    SHORT_DESC = "Replaces all tags without tag plugin with their respective values from the node meta data"

    def init
      UPS::Registry['Tags'].tags[:default] = self
    end

    def process_tag( tag, content, node, templateNode )
      node[tag] || ''
    end

    UPS::Registry.register_plugin MetaTag

  end

end
