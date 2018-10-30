using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

namespace tinyMCE
{
    public class TextEditor : TextBox
    {
        protected override void OnPreRender(EventArgs e)
        {
            string tinyMceIncludeKey = "TinyMCEInclude";
            string tinyMceIncludeScript = "<script type=\"text/javascript\" src=\"/General/Js/tiny_mce/tiny_mce.js\"></script>";

            if (!Page.ClientScript.IsStartupScriptRegistered(tinyMceIncludeKey))
            {
                Page.ClientScript.RegisterStartupScript(this.GetType(), tinyMceIncludeKey, tinyMceIncludeScript);
            }

            if (!Page.ClientScript.IsStartupScriptRegistered(GetInitKey()))
            {
                Page.ClientScript.RegisterStartupScript(this.GetType(), GetInitKey(), GetInitScript());
            }

            if (!CssClass.Contains(GetEditorClass())) //probably this is not the best way how to add the css class but I do not know any beter way
            {
                if (CssClass.Length > 0)
                {
                    CssClass += " ";
                }
                CssClass += GetEditorClass();
            }
            base.OnPreRender(e);
        }

        private string GetInitKey()
        {
            string simpleKey = "TinyMCESimple";
            string fullKey = "TinyMCEFull";

            switch (Mode)
            {
                case TextEditorMode.Simple:
                    return simpleKey;
                case TextEditorMode.Full:
                    return fullKey;
                default:
                    goto case TextEditorMode.Simple;
            }
        }

        private string GetEditorClass()
        {
            return GetEditorClass(Mode);
        }

        private string GetEditorClass(TextEditorMode mode)
        {
            string simpleClass = "SimpleTextEditor";
            string fullClass = "FullTextEditor";

            switch (mode)
            {
                case TextEditorMode.Simple:
                    return simpleClass;
                case TextEditorMode.Full:
                    return fullClass;
                default:
                    goto case TextEditorMode.Simple;
            }
        }

        private string GetInitScript()
        {
            string simpleScript =
                "<script language=\"javascript\" type=\"text/javascript\">tinyMCE.init({{mode : \"textareas\",relative_urls : false,convert_urls : false, theme : \"simple\",editor_selector : \"{0}\"}});</script>";
            string fullScript =
                "<script language=\"javascript\" type=\"text/javascript\">tinyMCE.init({{mode : \"textareas\",relative_urls : false,convert_urls : false, theme : \"advanced\",theme_advanced_toolbar_location : \"top\",theme_advanced_buttons1 : \"save,newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,styleselect,formatselect,fontselect,fontsizeselect\",theme_advanced_buttons2 : \"cut,copy,paste,pastetext,pasteword,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code,|,forecolor,backcolor\",editor_selector : \"{0}\"}});</script>";
        //        "<script language=\"javascript\" type=\"text/javascript\">tinyMCE.init({{  mode : \"textareas\", theme : \"advanced\", plugins : \"autolink,lists,spellchecker,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,imagemanager,filemanager\","
        //// Theme options
        //        + "theme_advanced_buttons1 : \"save,newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,styleselect,formatselect,fontselect,fontsizeselect\","
        //        + "theme_advanced_buttons2 : \"cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code,|,insertdate,inserttime,preview,|,forecolor,backcolor\","
        //        + "theme_advanced_buttons3 : \"tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,emotions,iespell,media,advhr,|,print,|,ltr,rtl,|,fullscreen\","
        //        + "theme_advanced_buttons4 : \"insertlayer,moveforward,movebackward,absolute,|,styleprops,spellchecker,|,cite,abbr,acronym,del,ins,attribs,|,visualchars,nonbreaking,template,blockquote,pagebreak,|,insertfile,insertimage\","
        //        + "theme_advanced_toolbar_location : \"top\","
        //        + "theme_advanced_toolbar_align : \"left\","
        //        + "theme_advanced_statusbar_location : \"bottom\","
        //        + "theme_advanced_resizing : true,"
        //        + "width: \"100%\","
        //        + "height: \"400\","
        //        + "editor_selector : \"{0}\""
        //        + " }});"
        //        + "</script>";

            switch (Mode)
            {
                case TextEditorMode.Simple:
                    return string.Format(simpleScript, GetEditorClass(TextEditorMode.Simple));
                case TextEditorMode.Full:
                    return string.Format(fullScript, GetEditorClass(TextEditorMode.Full));
                default:
                    goto case TextEditorMode.Simple;
            }
        }

        public override TextBoxMode TextMode
        {
            get
            {
                return TextBoxMode.MultiLine;
            }
        }

        public TextEditorMode Mode
        {
            get
            {
                Object obj = ViewState["Mode"];
                if (obj == null)
                {
                    return TextEditorMode.Simple;
                }
                return (TextEditorMode)obj;
            }
            set
            {
                ViewState["Mode"] = value;
            }
        }

        public enum TextEditorMode
        {
            Simple,
            Full
        }
    }
}
