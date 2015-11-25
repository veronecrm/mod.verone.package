<div class="mod-updates">
  <div class="updates-core">
    <div class="update-tile update-loader">
      <i class="fa fa-spinner fa-spin"></i>
      <span>{{ t('packageUpdateChecking') }}</span>
    </div>
    <div class="update-tile success hidden">
      <i>0.0.0</i>
      <span>{{ t('packageUpdateCoreUpdateAvailable') }}</span>
    </div>
    <div class="update-tile no-updates hidden">
      <i class="fa fa-thumbs-o-up"></i>
      <span>{{ t('packageUpdateCoreIsUpdated') }}</span>
    </div>
    <div class="core-update-btn-holder hidden">
      <button type="button" class="btn btn-primary btn-update" data-uid="core.crm" data-version="">{{ t('packageUpdateUpdateSystem') }}</button>
      <a class="show-whats-new" data-uid="core.crm" href="#">{{ t('packageUpdateWhatsNew') }}</a>
    </div>
  </div>
  <div class="updates-modules">
    <div class="update-tile update-loader">
      <i class="fa fa-spinner fa-spin"></i>
      <span>{{ t('packageUpdateChecking') }}</span>
    </div>
    <div class="update-tile success hidden">
      <i>0</i>
      <span>{{ t('packageUpdateModulesUpdateAvailable') }}</span>
    </div>
    <div class="update-tile no-updates hidden">
      <i class="fa fa-thumbs-o-up"></i>
      <span>{{ t('packageUpdateModulesAreUpdated') }}</span>
    </div>
    <div class="modules-updates-holder hidden"></div>
  </div>
</div>
<div class="modal fade" id="updates-whats-new">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="{{ t('close') }}"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="chat-settings-modal-label">{{ t('packageUpdateWhatsNew') }}</h4>
      </div>
      <div class="modal-body">
        
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default btn-cancel" data-dismiss="modal">{{ t('close') }}</button>
      </div>
    </div>
  </div>
</div>
<div class="ve-panel update-panel-progress hidden">
  <div class="ve-bl"></div>
  <div class="ve-fl">
    <h4>{{ t('packageUpdateUpdateInProgress') }}</h4>
    <p></p>
    <div class="progress">
      <div class="progress-bar progress-bar-striped active" role="progressbar" style="width:0px;"></div>
    </div>
  </div>
</div>
<style>
  .mod-updates {max-width:1000px;width:100%;padding:20px 10px;}
  .mod-updates:after {content:" ";display:table;clear:both;}
  .mod-updates > div {width:50%;float:left;padding:0 10px;}
  .update-tile {width:100%;border:1px solid #ddd;text-align:center;background-color:#fff;padding:20px 30px;border-radius:3px;margin-bottom:60px;}
  .update-tile .fa {font-size:140px;color:#dddddd;display:block;margin:20px 0 40px 0;line-height:1;}
  .update-tile span {display:block;font-size:20px;}
  .update-tile.success i {display:block;font-style:normal;font-size:60px;color:#29b12b;margin:80px 0;line-height:1;}
  .core-update-btn-holder {text-align:center;}
  .core-update-btn-holder button {font-size:18px;text-transform:uppercase;border-radius:3px;clear:both;display:inline-block;padding:10px 30px;}
  .core-update-btn-holder a {font-size:14px;color:#444;display:block;padding:4px;margin-top:6px;}
  .modules-updates-holder {background-color:#fff;border-radius:3px;border:1px solid #ddd;display:table;width:100%;}
  .modules-updates-holder .module {display:table-row;}
  .modules-updates-holder .module > div {border-bottom:1px solid #ddd;padding:10px 14px;font-size:13px;color:#5f5f5f;display:table-cell;}
  .modules-updates-holder .module:last-child > div {border-bottom:none;}
  .modules-updates-holder .module:hover > div {background-color:#fafafa}
  .modules-updates-holder .module .name small {display:block;font-size:80%;opacity:.8}
  .modules-updates-holder .module .whats-new {text-align:right;}
  .modules-updates-holder .module .whats-new a {color:#333}
  .modules-updates-holder .module .update {text-align:right;color:#0088CC;font-weight:bold;}
</style>
<script>
  var updatePackages = [];

  var checkUpdates = function() {
    $('.modules-updates-holder').html('');
    $('.updates-core .core-update-btn-holder').addClass('hidden');
    $('.updates-core .core-update-btn-holder .show-whats-new').removeClass('hidden');
    $('.updates-core .update-tile').addClass('hidden');
    $('.updates-core .update-loader').removeClass('hidden');


    $('.updates-modules .modules-updates-holder').addClass('hidden');
    $('.updates-modules .update-tile').addClass('hidden');
    $('.updates-modules .update-loader').removeClass('hidden');

    APP.AJAX.call({
      url: APP.createUrl('Package', 'Update', 'check'),
      success: function(data) {
        var coreUpdateAvailable = false;
        var modulesUpdatesCount = 0;

        updatePackages = data.packages;

        for(var i in data.packages)
        {
          if(data.packages[i].uid == 'core.crm')
          {
            coreUpdateAvailable = true;

            $('.updates-core .update-tile.success i').text(data.packages[i].version);
            $('.updates-core .core-update-btn-holder .btn-update').attr('data-version', data.packages[i].version);

            if(data.packages[i].changes == '')
            {
              $('.updates-core .core-update-btn-holder .show-whats-new').addClass('hidden');
            }
          }
          else
          {
            modulesUpdatesCount++;

            $('.modules-updates-holder').append('<div class="module">'
        + '<div class="name">' + data.packages[i].localeName + ' <small>(' + data.packages[i].name + ')</small></div>'
        + '<div class="version">' + data.packages[i].version + '</div>'
        + '<div class="whats-new">' + (data.packages[i].changes ? '<a href="#" class="show-whats-new" data-uid="' + data.packages[i].uid + '">{{ t('packageUpdateWhatsNew') }}</a>' : '') + '</div>'
        + '<div class="update"><a href="#" data-uid="' + data.packages[i].uid + '" data-version="' + data.packages[i].version + '" class="btn-update">{{ t('packageUpdateDoUpdate') }}</a></div>'
      + '</div>');
          }
        }


        $('.updates-core .update-loader').addClass('hidden');

        if(coreUpdateAvailable)
        {
          $('.updates-core .core-update-btn-holder').removeClass('hidden');
          $('.updates-core .update-tile').addClass('hidden');
          $('.updates-core .update-tile.success').removeClass('hidden');
        }
        else
        {
          $('.updates-core .update-tile').addClass('hidden');
          $('.updates-core .no-updates').removeClass('hidden');
        }


        $('.updates-modules .update-loader').addClass('hidden');

        if(modulesUpdatesCount)
        {
          $('.updates-modules .modules-updates-holder').removeClass('hidden');
          $('.updates-modules .update-tile').addClass('hidden');
          $('.updates-modules .update-tile.success').removeClass('hidden').find('i').text(modulesUpdatesCount);
        }
        else
        {
          $('.updates-modules .update-tile').addClass('hidden');
          $('.updates-modules .no-updates').removeClass('hidden');
        }
      }
    });
  };

  $(function() {
    checkUpdates();

    $('.mod-updates').on('click', '.show-whats-new', function() {
      var modal = $('#updates-whats-new');
      var uid   = $(this).attr('data-uid');

      for(var i in updatePackages)
      {
        if(updatePackages[i].uid == uid)
        {
          modal.find('.modal-body').html(updatePackages[i].changes);
        }
      }

      modal.modal();

      return false;
    });

    $('.mod-updates').on('click', '.btn-update', function() {
      (new Updater($(this).attr('data-uid'), $(this).attr('data-version'), checkUpdates)).start();

      return false;
    });
  });

  var Updater = function(uid, version, refreshFunction) {
    this.uid     = uid;
    this.version = version;
    this.refresh = refreshFunction;

    this.currentStep = -1;

    this.steps = [
      {
        title: '{{ t('packageUpdateDownloadingUpdatePackage') }}',
        url  : APP.createUrl('Package', 'Updater', 'downloadPackage')
      },
      {
        title: '{{ t('packageUpdateBackupCreating') }}',
        url  : APP.createUrl('Package', 'Updater', 'backup')
      },
      {
        title: '{{ t('packageUpdateUpdateInstallation') }}',
        url  : APP.createUrl('Package', 'Updater', 'install')
      },
      {
        title: '{{ t('packageUpdateUpdateFinalization') }}',
        url  : APP.createUrl('Package', 'Updater', 'finalization')
      }
    ];

    this.start = function() {
      APP.VEPanel.open('.update-panel-progress', true);

      this.runNextStep();
    };

    this.runNextStep = function() {
      this.currentStep++;
      var self = this;

      if(this.currentStep == this.steps.length)
      {
        setTimeout(function() {
          self.reset();
          APP.VEPanel.close();
        }, 500);

        self.refresh();
        self.moveProgressbar(self.steps.length, self.steps.length);

        return;
      }

      var step = this.steps[this.currentStep];

      $('.update-panel-progress p').text(step.title);

      APP.AJAX.call({
        url: step.url,
        data: {
          uid     : this.uid,
          version : this.version
        },
        success: function(data) {
          if(data == 'go-next')
          {
            self.moveProgressbar(self.currentStep, self.steps.length);
            self.runNextStep();
          }
          else
          {
            self.reset();
            APP.VEPanel.close();
            self.refresh();
          }
        },
        error: function() {
          self.reset();
          APP.FluidNotification.open('{{ t('packageUpdateFailsPleaseRetry') }}', { theme: 'error' });
          APP.VEPanel.close();
          self.refresh();
        }
      });
    };

    this.reset = function() {
      this.currentStep = -1;
      this.moveProgressbar(this.currentStep, this.steps.length);
    };

    this.moveProgressbar = function(step, steps) {
      $('.update-panel-progress .progress-bar').css('width', (((step + 1) / steps) * 100) + '%');
    };
  };
</script>
