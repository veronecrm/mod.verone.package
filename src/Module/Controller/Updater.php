<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Package\Controller;

use CRM\App\Controller\BaseController;
use CRM\Update\API\Client;
use CRM\Version;

/**
 * @section mod.Package.Updater
 */
class Updater extends BaseController
{

  /**
   * @access core.module
   */
  public function downloadPackageAction($request)
  {
    $client = $this->createClient($request);

    if($client == null)
    {
      return $this->responseAJAX([
        'status'  => 'error',
        'message' => $this->t('packageUpdateUpdateServerTemporaryUnavailable')
      ]);
    }

    $result = $client->downloadPackage($request->request->get('uid'), $request->request->get('version'), BASEPATH.'/app/Cache/Package/Update');

    if(is_file($result))
    {
      $zip = new \ZipArchive;

      // We must check, if download ZIP is not broken.
      if($zip->open($result))
      {
        $request->getSession()->set('mod.update.package-path', $result);

        return $this->responseAJAX([
          'status' => 'success',
          'data'   => 'go-next'
        ]);
      }
      else
      {
        return $this->responseAJAX([
          'status'  => 'error',
          'message' => $this->t('packageUpdateDownloadPackageHaveErrorUnableToInstall')
        ]);
      }
    }
    else
    {
      return $this->responseAJAX([
        'status'  => 'error',
        'message' => $this->t('packageUpdateUpdateServerHaventUpdatePackageFile')
      ]);
    }
  }


  /**
   * @access core.module
   */
  public function backupAction($request)
  {
    $packagePath = $request->getSession()->get('mod.update.package-path');

    try
    {
      $updater = $this->get('package.update.factory')->create($packagePath);

      if($updater->getType() == 'module')
      {
        $module = $this->db()->builder()->where('uid', $updater->getUID())->from('#__module')->one();

        if(! $module)
        {
          return $this->responseAJAX([
            'status'  => 'error',
            'message' => $this->t('packageUpdateModuleNotInstalledForThisPackage')
          ]);
        }

        $backupSourcePath = BASEPATH.'/app/App/Module/'.$module->name;
      }
      else
      {
        $backupSourcePath = BASEPATH;
      }

      $updater->backupFiles($backupSourcePath, BASEPATH.'/app/Cache/Backup/Package/Update/'.date('Y-m-d_H-i-s').'/'.basename($packagePath));
    }
    catch(\Exception $e)
    {
      return $this->responseAJAX([
        'status'  => 'error',
        'message' => 'Błąd: '.$e->getMessage()
      ]);
    }

    return $this->responseAJAX([
      'status'  => 'success',
      'data'    => 'go-next'
    ]);
  }


  /**
   * @access core.module
   */
  public function installAction($request)
  {
    $packagePath = $request->getSession()->get('mod.update.package-path');

    try
    {
      $updater = $this->get('package.update.factory')->create($packagePath);
      $updater->install();

      if($updater->installFileExists())
      {
        $obj = $updater->getInstallFileObject();

        if(method_exists($obj, 'setContainer'))
        {
          $obj->setContainer($this->container);
        }

        if(method_exists($obj, 'install'))
        {
          $obj->install();
        }
      }

      // Update module version in DB
      if($updater->getType() == 'module')
      {
        $this->db()->builder()->where('uid', $updater->getUID())->update('#__module', [
          'version'     => $updater->getVersion(),
          'versionDate' => $updater->getReleaseDate()
        ]);
      }
    }
    catch(\Exception $e)
    {
      return $this->responseAJAX([
        'status'  => 'error',
        'message' => 'Błąd: '.$e->getMessage()
      ]);
    }

    return $this->responseAJAX([
      'status' => 'success',
      'data'   => 'go-next'
    ]);
  }


  /**
   * @access core.module
   */
  public function finalizationAction($request)
  {
    $packagePath = $request->getSession()->get('mod.update.package-path');

    try
    {
      $updater = $this->get('package.update.factory')->create($packagePath);
      $updater->cleanUp();
    }
    catch(\Exception $e)
    {
      return $this->responseAJAX([
        'status'  => 'error',
        'message' => 'Błąd: '.$e->getMessage()
      ]);
    }

    // Remove downloaded file.
    if(is_file($packagePath))
    {
      unlink($packagePath);
    }

    return $this->responseAJAX([
      'status' => 'success',
      'data'   => 'go-next'
    ]);
  }

  public function createClient($request)
  {
    $settings = $this->openSettings('app');

    try
    {
      $client = new Client($settings->get('id'), Version::VERSION, $settings->get('packageUpdate.api.server'));
      $client->setSessionId($request->getSession()->get('mod.update.api.sessionid'));

      // Init session with current ID, or create new one.
      $client->initSession();
    }
    catch(\Exception $e)
    {
      $client = null;
    }

    return $client;
  }
}
