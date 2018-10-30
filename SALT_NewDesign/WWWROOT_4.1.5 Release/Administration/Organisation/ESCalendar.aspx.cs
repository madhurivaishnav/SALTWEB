using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Bdw.Application.Salt.Web.General.UserControls.EmergingControls
{
    public partial class ESCalendar : System.Web.UI.Page
    {
        private int lDayParam;
        private int lMthParam;
        private int lYrParam;
        public int pDayParam
        {
            get
            {
                return lDayParam;
            }
            set
            {
                lDayParam = value;
            }
        }
        public int pMthParam
        {
            get
            {
                return lMthParam;
            }
            set
            {
                lMthParam = value;
            }
        }
        public int pYrParam
        {
            get
            {
                return lYrParam;
            }
            set
            {
                lYrParam = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Calendar2_SelectionChanged(object sender, EventArgs e)
        {
            txtDay.Text = Calendar2.SelectedDate.Day.ToString();
            txtMth.Text = Calendar2.SelectedDate.Month.ToString();
            txtYr.Text = Calendar2.SelectedDate.Year.ToString();
        }

        protected void Calendar2_Init1(object sender, EventArgs e)
        {

            System.Globalization.CultureInfo culture;
            System.Globalization.DateTimeStyles styles;
            System.DateTime SelDate = System.DateTime.MinValue;
            if (HttpContext.Current.Request.Browser.Browser == "IE" && HttpContext.Current.Request.Browser.MajorVersion >= 6) { Panel1.Width = 255; }
            else { Panel1.Height = 240; }


            
            culture = System.Globalization.CultureInfo.CreateSpecificCulture("en-AU");
            styles = System.Globalization.DateTimeStyles.None;
            DateTime.TryParse(Request.QueryString[0].ToString(), culture, styles, out SelDate);



            
            if (SelDate == System.DateTime.MinValue)
            {
                SelDate = System.DateTime.Now;
            }
            if (Calendar2.VisibleDate.ToString() == "30/12/2199 12:00:00 AM")
            {
                Calendar2.SelectedDate = SelDate;
                Calendar2.VisibleDate = SelDate;
            }
            txtDay.Text = Calendar2.SelectedDate.Day.ToString();
            txtMth.Text = Calendar2.SelectedDate.Month.ToString();
            txtYr.Text = Calendar2.SelectedDate.Year.ToString();
        }



    }
}