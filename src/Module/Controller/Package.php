<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 - 2016 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Package\Controller;

use Exception;
use CRM\App\Controller\BaseController;

/**
 * @section mod.Package.Package
 */
class Package extends BaseController
{
    /**
     * @access core.module
     */
    public function indexAction()
    {
        return $this->render('', [
            'modules' => $this->get('package.module.manager')->all()
        ]);
    }

    /**
     * @access core.module
     */
    public function installAction($request)
    {
        return $this->render();
    }

    /**
     * @access core.module
     */
    public function processInstallAction()
    {
        if(is_file($_FILES['package']['tmp_name']) === false)
        {
            return $this->redirect('Package', 'Package', 'install');
        }

        try
        {
            $installator = $this->get('package.install.factory')->create($_FILES['package']['tmp_name']);
        }
        catch(Exception $e)
        {
            $this->flash('danger', $e->getMessage());
            return $this->redirect('Package', 'Package', 'install');
        }

        try
        {
            $installator->install();
        }
        catch(Exception $e)
        {
            $this->log(sprintf($this->t('packageModuleInstallationLogError'), $installator->getManifest()->get('name'), $e->getMessage()), 2, 'Package');
            $this->flash('danger', $e->getMessage());
            $this->flash('installator.logs', $installator->getLogs());
            return $this->redirect('Package', 'Package', 'install');
        }

        $this->log(sprintf($this->t('packageModuleInstallationLogSuccess'), $installator->getManifest()->get('name')), 2, 'Package');

        $this->flash('installator.logs', $installator->getLogs());
        $this->flash('success', $this->t('packageModuleInstalledSuccesfully'));
        return $this->redirect('Package', 'Package', 'install');
    }

    /**
     * @access core.module
     */
    public function processUninstallAction($request)
    {
        $directory = BASEPATH.'/app/App/Module/'.$request->query->get('packageName');

        if(is_dir($directory) === false)
        {
            $this->flash('danger', $this->t('packageModuleDoesntExists'));
            return $this->redirect('Package', 'Package', 'index');
        }

        try
        {
            $uninstallator = $this->get('package.uninstall.factory')->create($directory);
        }
        catch(Exception $e)
        {
            $this->flash('danger', $e->getMessage());
            return $this->redirect('Package', 'Package', 'index');
        }

        try
        {
            $uninstallator->uninstall();
        }
        catch(Exception $e)
        {
            $this->log(sprintf($this->t('packageModuleUnnstallationLogError'), $uninstallator->getManifest()->get('name'), $e->getMessage()), 2, 'Package');
            $this->flash('danger', $e->getMessage());
            $this->flash('uninstallator.logs', $uninstallator->getLogs());
            return $this->redirect('Package', 'Package', 'index');
        }

        $this->log(sprintf($this->t('packageModuleUnnstallationLogSuccess'), $uninstallator->getManifest()->get('name')), 2, 'Package');
        $this->flash('uninstallator.logs', $uninstallator->getLogs());
        $this->flash('success', $this->t('packageModuleUninstalledSuccesfully'));
        return $this->redirect('Package', 'Package', 'index');
    }
}
