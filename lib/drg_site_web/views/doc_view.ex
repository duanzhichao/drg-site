defmodule DrgSiteWeb.DocView do
  use DrgSiteWeb, :view

  def render("index.json", %{doc: doc, page: page, page_list: page_list}) do
    %{data: render_many(doc, DrgSiteWeb.DocView, "doc.json"), page: page, page_list: page_list}
  end

  def render("show.json", %{doc: doc}) do
    %{data: render_one(doc, DrgSiteWeb.DocView, "doc.json")}
  end

  def render("doc.json", %{doc: doc}) do
    %{id: doc.id,
      doc_title: doc.doc_title,
      doc_time: doc.doc_time,
      doc_number: doc.doc_number,
      doc_from: doc.doc_from,
      doc_type: doc.doc_type,
      doc_object: doc.doc_object,
      doc_content: doc.doc_content,
      doc_contact: doc.doc_contact,
      doc_inscribe: doc.doc_inscribe,
      ishave_file: doc.ishave_file,
      file: doc.file,
      browse_volume: doc.browse_volume,
      up_user: doc.up_user,
      up_time: doc.up_time}
  end
end
