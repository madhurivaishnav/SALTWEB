using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Bdw.Application.Salt.Web.General.UserControls.EmergingControls
{
    public partial class EmergingSystemsCalendar : System.Web.UI.UserControl
    {
        private string lDayField;
        private string lMthField;
        private string lYrField;
        public string DayFieldName
        {
            get
            {
                return lDayField;
            }
            set
            {
                lDayField = value;
            }
        }
        public string MonthFieldName
        {
            get
            {
                return lMthField;
            }
            set
            {
                lMthField = value;
            }
        }
        public string YearFieldName
        {
            get
            {
                return lYrField;
            }
            set
            {
                lYrField = value;
            }
        }

    }
}