require 'rails_helper'

RSpec.describe Dataformats::Xml::Path do
  it "converts to xpath" do
    path = Dataformats::Xml::Path.new(['e:eac', 'e:condesc', 'e:desc', 'e:persdesc', 'e:existdesc', 'e:existdate', { :scope => 'begin' }], {'e' => "http://xml.ra.se/EAC"})
    expect(path.as_xpath).to eq('//e:eac/e:condesc/e:desc/e:persdesc/e:existdesc/e:existdate[@scope="begin"]')
  end

  it "converts to xpath" do
    path = Dataformats::Xml::Path.new(['e:eac', 'e:condesc', 'e:identity', 'e:pershead', { :authorized => 'dArc' }, 'e:part', { :type => 'surname' }], {'e' => "http://xml.ra.se/EAC"})
    expect(path.as_xpath).to eq('//e:eac/e:condesc/e:identity/e:pershead[@authorized="dArc"]/e:part[@type="surname"]')
  end

  it "creates missing elements" do
    test_create ['e:a', 'e:b'], {ns_p => ns_u}, '<a xmlns="http://xml.ra.se/EAC"/>', '<a xmlns="http://xml.ra.se/EAC"><b/></a>'
  end

  it "creates missing elements with namespace prefix" do
    test_create ['e:a', 'e:b'], {ns_p => ns_u}, '<e:a xmlns:e="http://xml.ra.se/EAC"/>', '<e:a xmlns:e="http://xml.ra.se/EAC"><e:b/></a>'
  end

  it "creates missing elements by attribute already present" do
    test_create ['e:a', 'e:b', { :c => 'd' }], {ns_p => ns_u}, '<a xmlns="http://xml.ra.se/EAC"><b c="d"/></a>', '<a xmlns="http://xml.ra.se/EAC"><b c="d"/></a>'
  end

  it "creates missing elements by attribute same attribute exists" do
    test_create ['e:a', 'e:b', { :c => 'd2' }], {ns_p => ns_u}, '<a xmlns="http://xml.ra.se/EAC"><b c="d1"/></a>', '<a xmlns="http://xml.ra.se/EAC"><b c="d1"/><b c="d2"/></a>'
  end

  it "creates missing elements double namespace" do
    test_create ['ns1:a', 'ns2:b', 'ns2:c'], {'ns1' => 'ns1u', 'ns2' => 'ns2u'}, '<ns1:a xmlns:ns1="ns1u" xmlns:ns2="ns2u"><ns2:b/></a>', '<ns1:a xmlns:ns1="ns1u" xmlns:ns2="ns2u"><ns2:b><ns2:c/></ns2:b></a>'
  end

  it "creates missing elements double namespace for dc" do
    test_create ['oai_dc:dc', 'dc:title'], {'dc' => "http://purl.org/dc/elements/1.1/", 'oai_dc' => "http://www.openarchives.org/OAI/2.0/oai_dc/"}, '<oai_dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd"><dc:identifier>darc:66</dc:identifier></oai_dc:dc>', '<oai_dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd"><dc:identifier>darc:66</dc:identifier><dc:title/></oai_dc:dc>'
  end
  
  def test_create path, ns, in_xml, expect_xml
    path = Dataformats::Xml::Path.new(path, ns)
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
