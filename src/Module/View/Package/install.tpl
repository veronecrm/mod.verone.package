<div class="page-header">
  <div class="page-header-content">
    <div class="page-title">
      <h1>
        <i class="fa fa-cubes"></i>
        {{ t('packageInstallModule') }}
      </h1>
    </div>
    <div class="heading-elements">
      <div class="heading-btn-group">
        <a href="#" data-form-submit="form" data-form-param="save" class="btn btn-icon-block btn-link-success">
          <i class="fa fa-upload"></i>
          <span>{{ t('packageInstall') }}</span>
        </a>
      </div>
    </div>
    <div class="heading-elements-toggle">
      <i class="fa fa-ellipsis-h"></i>
    </div>
  </div>
  <div class="breadcrumb-line">
    <ul class="breadcrumb">
      <li><a href="{{ createUrl() }}"><i class="fa fa-home"> </i>Verone</a></li>
      <li><a href="{{ createUrl('Package', 'Package', 'index') }}">{{ t('modNamePackage') }}</a></li>
      <li class="active"><a href="{{ createUrl('Package', 'Package', 'install') }}">{{ t('packageInstallModule') }}</a></li>
    </ul>
  </div>
</div>

<div class="container-fluid">
  <div class="row">
    <div class="col-md-12">
      <form action="{{ createUrl('Package', 'Package', 'processInstall') }}" method="post" enctype="multipart/form-data" id="form">
        <div class="input-group">
          <span class="input-group-btn">
            <label class="btn btn-primary btn-file">{{ t('selectFile') }}&hellip; <input type="file" name="package" id="package" /></label>
          </span>
          <input type="text" class="form-control" id="package_name" readonly>
          <span class="input-group-btn">
            <a data-form-submit="form" data-form-param="save" class="btn btn-success"><i class="fa fa-upload"></i> {{ t('packageInstall') }}</a>
          </span>
        </div>
      </form>
      <?php
        foreach($app->flashBag()->get('installator.logs', []) as $flash)
        {
          echo '<div class="bg-info" style="padding:10px;margin-top:12px;"><strong>'.$app->t('packageInstallationLogs').'</strong><br /><br />'.implode('<br />', $flash).'</div>';
        }
      ?>
    </div>
  </div>
</div>

<script>
function handleFileSelect(evt) {
  var files = evt.target.files;

  for(var i = 0, f; f = files[i]; i++)
  {
    document.getElementById('package_name').value = escape(f.name);
  }
}
$(document).ready(function() {
  document.getElementById('package').addEventListener('change', handleFileSelect, false);
});
</script>
