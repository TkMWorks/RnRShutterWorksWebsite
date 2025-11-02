namespace UploadUtility
{
    partial class MainWindow
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainWindow));
            tblpnlMain = new TableLayoutPanel();
            tblpnlImageViewer = new TableLayoutPanel();
            tblpnlPreviewContainer = new TableLayoutPanel();
            pbImage = new PictureBox();
            btnPreviousImage = new Button();
            btnNextImage = new Button();
            rtbCaption = new RichTextBox();
            tblpnlImageButtons = new TableLayoutPanel();
            btnBrowse = new Button();
            btnSave = new Button();
            tblpnlGridControls = new TableLayoutPanel();
            rtbStatus = new RichTextBox();
            dgvUploadData = new DataGridView();
            tblpnlUploadButton = new TableLayoutPanel();
            btnUpload = new Button();
            dlgBrowse = new FolderBrowserDialog();
            tblpnlMain.SuspendLayout();
            tblpnlImageViewer.SuspendLayout();
            tblpnlPreviewContainer.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)pbImage).BeginInit();
            tblpnlImageButtons.SuspendLayout();
            tblpnlGridControls.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)dgvUploadData).BeginInit();
            tblpnlUploadButton.SuspendLayout();
            SuspendLayout();
            // 
            // tblpnlMain
            // 
            tblpnlMain.CellBorderStyle = TableLayoutPanelCellBorderStyle.Inset;
            tblpnlMain.ColumnCount = 1;
            tblpnlMain.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100F));
            tblpnlMain.Controls.Add(tblpnlImageViewer, 0, 0);
            tblpnlMain.Controls.Add(tblpnlImageButtons, 0, 1);
            tblpnlMain.Controls.Add(tblpnlGridControls, 0, 2);
            tblpnlMain.Controls.Add(tblpnlUploadButton, 0, 3);
            tblpnlMain.Dock = DockStyle.Fill;
            tblpnlMain.Location = new Point(0, 0);
            tblpnlMain.Name = "tblpnlMain";
            tblpnlMain.RowCount = 4;
            tblpnlMain.RowStyles.Add(new RowStyle(SizeType.Percent, 65F));
            tblpnlMain.RowStyles.Add(new RowStyle(SizeType.Absolute, 70F));
            tblpnlMain.RowStyles.Add(new RowStyle(SizeType.Percent, 35F));
            tblpnlMain.RowStyles.Add(new RowStyle(SizeType.Absolute, 70F));
            tblpnlMain.Size = new Size(954, 722);
            tblpnlMain.TabIndex = 0;
            // 
            // tblpnlImageViewer
            // 
            tblpnlImageViewer.CellBorderStyle = TableLayoutPanelCellBorderStyle.Inset;
            tblpnlImageViewer.ColumnCount = 2;
            tblpnlImageViewer.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 70F));
            tblpnlImageViewer.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 30F));
            tblpnlImageViewer.Controls.Add(tblpnlPreviewContainer, 0, 0);
            tblpnlImageViewer.Controls.Add(rtbCaption, 1, 0);
            tblpnlImageViewer.Dock = DockStyle.Fill;
            tblpnlImageViewer.Location = new Point(5, 5);
            tblpnlImageViewer.Name = "tblpnlImageViewer";
            tblpnlImageViewer.RowCount = 1;
            tblpnlImageViewer.RowStyles.Add(new RowStyle(SizeType.Percent, 100F));
            tblpnlImageViewer.Size = new Size(944, 365);
            tblpnlImageViewer.TabIndex = 0;
            // 
            // tblpnlPreviewContainer
            // 
            tblpnlPreviewContainer.CellBorderStyle = TableLayoutPanelCellBorderStyle.Inset;
            tblpnlPreviewContainer.ColumnCount = 3;
            tblpnlPreviewContainer.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 70F));
            tblpnlPreviewContainer.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100F));
            tblpnlPreviewContainer.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 70F));
            tblpnlPreviewContainer.Controls.Add(pbImage, 1, 0);
            tblpnlPreviewContainer.Controls.Add(btnPreviousImage, 0, 0);
            tblpnlPreviewContainer.Controls.Add(btnNextImage, 2, 0);
            tblpnlPreviewContainer.Dock = DockStyle.Fill;
            tblpnlPreviewContainer.Location = new Point(5, 5);
            tblpnlPreviewContainer.Name = "tblpnlPreviewContainer";
            tblpnlPreviewContainer.RowCount = 1;
            tblpnlPreviewContainer.RowStyles.Add(new RowStyle(SizeType.Percent, 100F));
            tblpnlPreviewContainer.Size = new Size(650, 355);
            tblpnlPreviewContainer.TabIndex = 0;
            // 
            // pbImage
            // 
            pbImage.BackgroundImageLayout = ImageLayout.Stretch;
            pbImage.BorderStyle = BorderStyle.Fixed3D;
            pbImage.Dock = DockStyle.Fill;
            pbImage.Location = new Point(77, 5);
            pbImage.Name = "pbImage";
            pbImage.Padding = new Padding(50, 0, 50, 0);
            pbImage.Size = new Size(496, 345);
            pbImage.SizeMode = PictureBoxSizeMode.Zoom;
            pbImage.TabIndex = 0;
            pbImage.TabStop = false;
            // 
            // btnPreviousImage
            // 
            btnPreviousImage.Anchor = AnchorStyles.None;
            btnPreviousImage.Font = new Font("Arial", 12F, FontStyle.Bold);
            btnPreviousImage.Location = new Point(7, 147);
            btnPreviousImage.Name = "btnPreviousImage";
            btnPreviousImage.Size = new Size(60, 60);
            btnPreviousImage.TabIndex = 1;
            btnPreviousImage.Text = "<";
            btnPreviousImage.UseVisualStyleBackColor = true;
            btnPreviousImage.Click += btnPreviousImage_Click;
            // 
            // btnNextImage
            // 
            btnNextImage.Anchor = AnchorStyles.None;
            btnNextImage.Font = new Font("Arial", 12F, FontStyle.Bold, GraphicsUnit.Point, 0);
            btnNextImage.Location = new Point(583, 147);
            btnNextImage.Name = "btnNextImage";
            btnNextImage.Size = new Size(60, 60);
            btnNextImage.TabIndex = 2;
            btnNextImage.Text = ">";
            btnNextImage.UseVisualStyleBackColor = true;
            btnNextImage.Click += btnNextImage_Click;
            // 
            // rtbCaption
            // 
            rtbCaption.Dock = DockStyle.Fill;
            rtbCaption.Font = new Font("Arial", 12F);
            rtbCaption.ForeColor = Color.Crimson;
            rtbCaption.Location = new Point(663, 5);
            rtbCaption.Name = "rtbCaption";
            rtbCaption.ScrollBars = RichTextBoxScrollBars.Vertical;
            rtbCaption.Size = new Size(276, 355);
            rtbCaption.TabIndex = 1;
            rtbCaption.Text = "";
            // 
            // tblpnlImageButtons
            // 
            tblpnlImageButtons.CellBorderStyle = TableLayoutPanelCellBorderStyle.Inset;
            tblpnlImageButtons.ColumnCount = 5;
            tblpnlImageButtons.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 45F));
            tblpnlImageButtons.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 150F));
            tblpnlImageButtons.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 10F));
            tblpnlImageButtons.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 150F));
            tblpnlImageButtons.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 45F));
            tblpnlImageButtons.Controls.Add(btnBrowse, 1, 0);
            tblpnlImageButtons.Controls.Add(btnSave, 3, 0);
            tblpnlImageButtons.Dock = DockStyle.Fill;
            tblpnlImageButtons.Location = new Point(5, 378);
            tblpnlImageButtons.Name = "tblpnlImageButtons";
            tblpnlImageButtons.RowCount = 1;
            tblpnlImageButtons.RowStyles.Add(new RowStyle(SizeType.Percent, 100F));
            tblpnlImageButtons.Size = new Size(944, 64);
            tblpnlImageButtons.TabIndex = 1;
            // 
            // btnBrowse
            // 
            btnBrowse.Dock = DockStyle.Fill;
            btnBrowse.Font = new Font("Arial", 12F);
            btnBrowse.Location = new Point(291, 5);
            btnBrowse.Name = "btnBrowse";
            btnBrowse.Size = new Size(144, 54);
            btnBrowse.TabIndex = 0;
            btnBrowse.Text = "B&rowse";
            btnBrowse.UseVisualStyleBackColor = true;
            btnBrowse.Click += btnBrowse_Click;
            // 
            // btnSave
            // 
            btnSave.Dock = DockStyle.Fill;
            btnSave.Font = new Font("Arial", 12F);
            btnSave.Location = new Point(508, 5);
            btnSave.Name = "btnSave";
            btnSave.Size = new Size(144, 54);
            btnSave.TabIndex = 1;
            btnSave.Text = "&Save";
            btnSave.UseVisualStyleBackColor = true;
            btnSave.Click += btnSave_Click;
            // 
            // tblpnlGridControls
            // 
            tblpnlGridControls.CellBorderStyle = TableLayoutPanelCellBorderStyle.Inset;
            tblpnlGridControls.ColumnCount = 2;
            tblpnlGridControls.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 60F));
            tblpnlGridControls.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 40F));
            tblpnlGridControls.Controls.Add(rtbStatus, 1, 0);
            tblpnlGridControls.Controls.Add(dgvUploadData, 0, 0);
            tblpnlGridControls.Dock = DockStyle.Fill;
            tblpnlGridControls.Location = new Point(5, 450);
            tblpnlGridControls.Name = "tblpnlGridControls";
            tblpnlGridControls.RowCount = 1;
            tblpnlGridControls.RowStyles.Add(new RowStyle(SizeType.Percent, 100F));
            tblpnlGridControls.Size = new Size(944, 194);
            tblpnlGridControls.TabIndex = 2;
            // 
            // rtbStatus
            // 
            rtbStatus.BackColor = SystemColors.Control;
            rtbStatus.BorderStyle = BorderStyle.None;
            rtbStatus.Dock = DockStyle.Fill;
            rtbStatus.Location = new Point(576, 7);
            rtbStatus.Margin = new Padding(10, 5, 5, 5);
            rtbStatus.Name = "rtbStatus";
            rtbStatus.ReadOnly = true;
            rtbStatus.ScrollBars = RichTextBoxScrollBars.Vertical;
            rtbStatus.Size = new Size(361, 180);
            rtbStatus.TabIndex = 1;
            rtbStatus.Text = "";
            // 
            // dgvUploadData
            // 
            dgvUploadData.AllowUserToAddRows = false;
            dgvUploadData.AllowUserToDeleteRows = false;
            dgvUploadData.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dgvUploadData.Dock = DockStyle.Fill;
            dgvUploadData.Location = new Point(5, 5);
            dgvUploadData.Margin = new Padding(3, 3, 10, 3);
            dgvUploadData.Name = "dgvUploadData";
            dgvUploadData.ReadOnly = true;
            dgvUploadData.RowHeadersWidth = 51;
            dgvUploadData.ScrollBars = ScrollBars.Vertical;
            dgvUploadData.Size = new Size(549, 184);
            dgvUploadData.TabIndex = 2;
            // 
            // tblpnlUploadButton
            // 
            tblpnlUploadButton.CellBorderStyle = TableLayoutPanelCellBorderStyle.Inset;
            tblpnlUploadButton.ColumnCount = 3;
            tblpnlUploadButton.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tblpnlUploadButton.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 150F));
            tblpnlUploadButton.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tblpnlUploadButton.Controls.Add(btnUpload, 1, 0);
            tblpnlUploadButton.Dock = DockStyle.Fill;
            tblpnlUploadButton.Location = new Point(5, 652);
            tblpnlUploadButton.Name = "tblpnlUploadButton";
            tblpnlUploadButton.RowCount = 1;
            tblpnlUploadButton.RowStyles.Add(new RowStyle(SizeType.Percent, 100F));
            tblpnlUploadButton.Size = new Size(944, 65);
            tblpnlUploadButton.TabIndex = 3;
            // 
            // btnUpload
            // 
            btnUpload.Dock = DockStyle.Fill;
            btnUpload.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnUpload.Location = new Point(400, 5);
            btnUpload.Name = "btnUpload";
            btnUpload.Size = new Size(144, 55);
            btnUpload.TabIndex = 0;
            btnUpload.Text = "&Upload";
            btnUpload.UseVisualStyleBackColor = true;
            btnUpload.Click += btnUpload_Click;
            // 
            // dlgBrowse
            // 
            dlgBrowse.AddToRecent = false;
            dlgBrowse.RootFolder = Environment.SpecialFolder.MyComputer;
            dlgBrowse.ShowNewFolderButton = false;
            // 
            // MainWindow
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(954, 722);
            Controls.Add(tblpnlMain);
            ForeColor = Color.Crimson;
            FormBorderStyle = FormBorderStyle.Fixed3D;
            Icon = (Icon)resources.GetObject("$this.Icon");
            MaximizeBox = false;
            Name = "MainWindow";
            Text = "R&R ShutterWorks Image Upload Utility";
            WindowState = FormWindowState.Maximized;
            tblpnlMain.ResumeLayout(false);
            tblpnlImageViewer.ResumeLayout(false);
            tblpnlPreviewContainer.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)pbImage).EndInit();
            tblpnlImageButtons.ResumeLayout(false);
            tblpnlGridControls.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)dgvUploadData).EndInit();
            tblpnlUploadButton.ResumeLayout(false);
            ResumeLayout(false);
        }

        #endregion

        private TableLayoutPanel tblpnlMain;
        private TableLayoutPanel tblpnlImageViewer;
        private TableLayoutPanel tblpnlPreviewContainer;
        private TableLayoutPanel tblpnlImageButtons;
        private TableLayoutPanel tblpnlGridControls;
        private TableLayoutPanel tblpnlUploadButton;
        private Button btnNextImage;
        private Button button2;
        private RichTextBox rtbCaption;
        private Button button3;
        private Button button4;
        private RichTextBox rtbStatus;
        private PictureBox pbImage;
        private Button btnPreviousImage;
        private Button btnBrowse;
        private Button btnSave;
        private Button btnUpload;
        private DataGridView dgvUploadData;
        private FolderBrowserDialog dlgBrowse;
    }
}
