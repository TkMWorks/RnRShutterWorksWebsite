using System.Data;

namespace UploadUtility
{
    public partial class MainWindow : Form
    {
        #region Fields
        private string _selectedFolder;
        private List<string> _listOfImageFiles;
        private int _currentImageIndex = 0;
        private DataTable _imageCaptionDetails;
        private readonly BindingSource _imageCaptionBindingSource = new BindingSource();
        #endregion

        #region Constructor
        public MainWindow()
        {
            InitializeComponent();
            InitializeFields();
            SetupDataTable();
            btnPreviousImage.Enabled = btnNextImage.Enabled = btnSave.Enabled = btnUpload.Enabled = false;
        }
        #endregion

        #region Properties
        private string SelectedFolder
        {
            get { return _selectedFolder; }
            set { _selectedFolder = value; }
        }

        private List<string> ListOfImageFiles
        {
            get { return _listOfImageFiles; }
            set { _listOfImageFiles = value; }
        }

        private int CurrentImageIndex {
            get { return _currentImageIndex; }
            set { _currentImageIndex = value; }
        }

        private DataTable ImageCaptionDetails
        {
            get { return _imageCaptionDetails; }
            set { _imageCaptionDetails = value; }
        }

        private BindingSource ImageCaptionBindingSource
        {
            get { return _imageCaptionBindingSource; }
        }
        #endregion

        #region Private Methods
        private void InitializeFields()
        {
            _selectedFolder = string.Empty;
        }

        private List<string> GetImageFileNamesFromFolder(string folderPath)
        {
            return (new DirectoryInfo(folderPath).GetFiles("*.*")
                .Where(file => file.Extension.Equals(".jpg", StringComparison.OrdinalIgnoreCase) ||
                               file.Extension.Equals(".jpeg", StringComparison.OrdinalIgnoreCase))
                .Select(c => c.FullName)).ToList();
        }

        private void DisplayImage()
        {
            try
            {
                if (ListOfImageFiles != null && ListOfImageFiles.Count > 0)
                {
                    pbImage.Image = Image.FromFile(ListOfImageFiles[CurrentImageIndex]);
                    btnPreviousImage.Enabled = CurrentImageIndex > 0;
                    btnNextImage.Enabled = CurrentImageIndex < ListOfImageFiles.Count - 1;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error displaying image: {ex.Message}");
            }
        }

        private void SetupDataTable()
        {
            ImageCaptionDetails = new DataTable();
            ImageCaptionDetails.Columns.Add("ImageFileName", typeof(string));
            ImageCaptionDetails.Columns.Add("Caption", typeof(string));
            ImageCaptionBindingSource.DataSource = ImageCaptionDetails;
            ImageCaptionBindingSource.ResetBindings(false);
            dgvUploadData.DataSource = ImageCaptionBindingSource;
            dgvUploadData.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvUploadData.AutoSizeRowsMode = DataGridViewAutoSizeRowsMode.AllCellsExceptHeaders;
            dgvUploadData.RowsDefaultCellStyle.WrapMode = DataGridViewTriState.True;
        }

        private string GetImageCaption(string fullPath)
        {
            if (ImageCaptionDetails != null && ImageCaptionDetails.Rows.Count > 0)
            {
                foreach (DataRow row in ImageCaptionDetails.Rows)
                {
                    if (row["ImageFileName"].ToString().Equals(fullPath, StringComparison.OrdinalIgnoreCase))
                    {
                        return row["Caption"].ToString();
                    }
                }
            }
            return string.Empty;
        }
        #endregion

        #region Event Handlers
        private void btnPreviousImage_Click(object sender, EventArgs e)
        {
            CurrentImageIndex--;
            DisplayImage();
            rtbCaption.Text = GetImageCaption(ListOfImageFiles[CurrentImageIndex]);
        }

        private void btnNextImage_Click(object sender, EventArgs e)
        {
            CurrentImageIndex++;
            DisplayImage();
            rtbCaption.Text = GetImageCaption(ListOfImageFiles[CurrentImageIndex]);
        }

        private void btnBrowse_Click(object sender, EventArgs e)
        {
            if (dlgBrowse.ShowDialog() == DialogResult.OK)
            {
                SelectedFolder = dlgBrowse.SelectedPath;
                btnSave.Enabled = true;
            }
            ListOfImageFiles = GetImageFileNamesFromFolder(SelectedFolder);
            if (ListOfImageFiles.Count > 0)
            {
                DisplayImage();
            }
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                DataRow row = ImageCaptionDetails.NewRow();
                row["ImageFileName"] = Path.GetFullPath(ListOfImageFiles[CurrentImageIndex]);
                row["Caption"] = rtbCaption.Text;
                ImageCaptionDetails.Rows.Add(row);
                ImageCaptionDetails.AcceptChanges();
            }
            catch (Exception ex)
            {
                ImageCaptionDetails.RejectChanges();
                MessageBox.Show($"Error displaying image: {ex.Message}");
            }
            finally
            {
                btnUpload.Enabled = ImageCaptionDetails.Rows.Count > 0;
            }
        }

        private void btnUpload_Click(object sender, EventArgs e)
        {

        } 
        #endregion
    }
}