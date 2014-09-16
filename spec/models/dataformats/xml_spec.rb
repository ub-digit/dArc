require 'rails_helper'

RSpec.describe Dataformats::Xml::Path do
  it "converts to xpath" do
    path = Dataformats::Xml::Path.new(['eac', 'condesc', 'desc', 'persdesc', 'existdesc', 'existdate', { :scope => 'begin' }], 'e', "http://xml.ra.se/EAC")
    expect(path.as_xpath).to eq('//e:eac/e:condesc/e:desc/e:persdesc/e:existdesc/e:existdate[@scope="begin"]')
  end

  it "converts to xpath" do
    path = Dataformats::Xml::Path.new(['eac', 'condesc', 'identity', 'pershead', { :authorized => 'dArc' }, 'part', { :type => 'surname' }], 'e', "http://xml.ra.se/EAC")
    expect(path.as_xpath).to eq('//e:eac/e:condesc/e:identity/e:pershead[@authorized="dArc"]/e:part[@type="surname"]')
  end

  it "creates missing elements" do
    test_create ['a', 'b'], ns_p, ns_u, '<a xmlns="http://xml.ra.se/EAC"/>', '<a xmlns="http://xml.ra.se/EAC"><b/></a>'
  end

  it "creates missing elements by attribute already present" do
    test_create ['a', 'b', { :c => 'd' }], ns_p, ns_u, '<a xmlns="http://xml.ra.se/EAC"><b c="d"/></a>', '<a xmlns="http://xml.ra.se/EAC"><b c="d"/></a>'
  end

  it "creates missing elements by attribute same attribute exists" do
    test_create ['a', 'b', { :c => 'd2' }], ns_p, ns_u, '<a xmlns="http://xml.ra.se/EAC"><b c="d1"/></a>', '<a xmlns="http://xml.ra.se/EAC"><b c="d1"/><b c="d2"/></a>'
  end
  
  def test_create path, ns_prefix, ns_uri, in_xml, expect_xml
    path = Dataformats::Xml::Path.new(path, ns_prefix, ns_uri)
    doc = Nokogiri::XML(in_xml)

    path.create(doc)

    expect(doc.to_xml).to eq(Nokogiri::XML(expect_xml).to_xml)
  end
  
  def ns_p
    'e'
  end
  
  def ns_u
    "http://xml.ra.se/EAC"
  end
end
