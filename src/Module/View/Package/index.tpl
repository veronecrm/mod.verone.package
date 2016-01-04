<div class="page-header">
    <div class="page-header-content">
        <div class="page-title">
            <h1>
                <i class="fa fa-cubes"></i>
                {{ t('packageModules') }}
            </h1>
        </div>
        <div class="heading-elements">
            <div class="heading-btn-group">
                <a href="{{ createUrl('Package', 'Package', 'install') }}" class="btn btn-icon-block">
                    <i class="fa fa-upload"></i>
                    <span>{{ t('packageInstallModule') }}</span>
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
            <li class="active"><a href="{{ createUrl('Package', 'Package', 'index') }}">{{ t('packageModules') }}</a></li>
        </ul>
        <ul class="breadcrumb-elements">
            <li><a href="{{ createUrl('Package', 'Update') }}"><i class="fa fa-circle-o-notch"></i> {{ t('packageUpdates') }}</a></li>
        </ul>
        <div class="breadcrumb-elements-toggle">
            <i class="fa fa-unsorted"></i>
        </div>
    </div>
</div>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <?php
                foreach($app->flashBag()->get('uninstallator.logs', []) as $flash)
                {
                    echo '<div class="bg-info" style="padding:10px;margin-top:12px;"><strong>'.$app->t('packageUninstallationLogs').'</strong><br /><br />'.implode('<br />', $flash).'</div>';
                }
            ?>
            <table class="table table-default table-responsive">
                <thead>
                    <tr>
                        <th>{{ t('name') }}</th>
                        <th class="text-center">{{ t('version') }}</th>
                        <th class="text-center">{{ t('author') }}</th>
                        <th class="text-center">{{ t('license') }}</th>
                        <th class="text-right">{{ t('action') }}</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach $modules
                        <tr>
                            <td data-th="{{ t('name') }}" class="th">
                                {{ $item->getNameLocale() }} &nbsp; <small style="opacity:.6">({{ $item->getUID() }})</small>
                            </td>
                            <td data-th="{{ t('version') }}" class="text-center">{{ $item->getVersion() }}</td>
                            <td data-th="{{ t('author') }}" class="text-center">
                                @if $item->getAuthorUrl()
                                    <a href="{{ $item->getAuthorUrl() }}" target="_blank">{{ $item->getAuthorName() }}</a>
                                @else
                                    {{ $item->getAuthorName() }}
                                @endif
                            </td>
                            <td data-th="{{ t('license') }}" class="text-center">{{ $item->getLicense() }}</td>
                            <td data-th="{{ t('action') }}">
                                <div class="actions-box">
                                    <div class="btn-group right">
                                        <a href="#" data-href="<?php echo $app->createUrl('Package', 'Package', 'processUninstall', [ 'packageName' => $item->getName() ]); ?>" class="btn btn-danger btn-xs btn-main-action" title="{{ t('packageUninstall') }}"><i class="fa fa-remove"></i></a>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal fade" id="package-uninstall-modal" tabindex="-1" role="dialog" aria-labelledby="package-uninstall-modal-label" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content modal-danger">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Zamknij"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="package-uninstall-modal-label">{{ t('packageModuleUninstalling') }}</h4>
            </div>
            <div class="modal-body">
                <h3 style="margin:0 0 15px 0">{{ t('packageAreYouSure') }}</h3>
                <p>{{ t('packageAreYouSureYouWantTouninstallThisModule') }}</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ t('cancel') }}</button>
                <button type="button" class="btn btn-danger">{{ t('packageUninstall') }}</button>
            </div>
        </div>
    </div>
</div>

<script>
    var currentRemovedModule = null;

    $(function() {
        $('.table .btn-main-action').click(function() {
            $('#package-uninstall-modal').modal();
            currentRemovedModule = $(this).attr('data-href');
        });

        $('#package-uninstall-modal .btn-danger').click(function() {
            $('#package-uninstall-modal').modal('hide');

            APP.ConfirmationPanel.open({
                onConfirm: function() {
                    document.location.href = currentRemovedModule;
                }
            });
        });
    });
</script>
