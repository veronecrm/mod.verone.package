<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 - 2016 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Package\Controller;

use CRM\App\Controller\BaseController;
use CRM\Package\Update\API\Client;
use CRM\Version;

/**
 * @section mod.Package.Update
 */
class Update extends BaseController
{
    /**
     * @access core.module
     */
    public function indexAction($request)
    {
        return $this->render('', [
                'modules' => $this->get('package.module.manager')->all()
        ]);
    }

    /**
     * @access core.module
     */
    public function checkAction($request)
    {
        $settings = $this->openSettings('app');

        try
        {
            $client = new Client($settings->get('id'), Version::VERSION, $settings->get('update.api.server'));
            $client->setSessionId($request->getSession()->get('mod.update.api.sessionid'));
            $client->initSession();
        }
        catch(\Exception $e)
        {
            return $this->responseAJAX([
                'status'  => 'error',
                'message' => $this->t('packageUpdateUpdateServerTemporaryUnavailable'),
                'data'    => ''
            ]);
        }

        // Save Session ID
        $request->getSession()->set('mod.update.api.sessionid', $client->getSessionId());

        $toCheck = [];

        // CRM Core we add manually, rest of modules we add from DB.
        $toCheck[] = [
            'uid'  => 'core.crm',
            'version' => Version::VERSION
        ];

        $modules = $this->get('package.module.manager')->all();

        foreach($modules as $module)
        {
            $toCheck[] = [
                'uid'     => $module->getUID(),
                'version' => $module->getVersion()
            ];
        }

        $result = $client->checkAvailability($toCheck);

        if(isset($result['packages']))
        {
            foreach($result['packages'] as $key => $val)
            {
                foreach($modules as $module)
                {
                    if($module->getUID() == $val['uid'])
                    {
                        $result['packages'][$key]['name'] = $module->getName();
                        $result['packages'][$key]['localeName'] = $this->t($module->getNameLocale());
                    }
                }

                if($val['uid'] == 'core.crm')
                {
                    $result['packages'][$key]['localeName'] = 'Verone CRM';
                }
            }
        }

        /**
         * Save data in session for global notificator.
         */
        $session = $request->getSession();
        $session->set('update.checked', '1');

        if($result['packages'] !== [])
        {
            $session->set('update.available', '1');
            $updateCore    = 0;
            $updateModules = 0;

            foreach($result['packages'] as $item)
            {
                if($item['uid'] == 'core.crm')
                {
                    $updateCore = 1;
                }
                else
                {
                    $updateModules++;
                }
            }

            $session->set('update.core.count', $updateCore);
            $session->set('update.module.count', $updateModules);
        }
        else
        {
            $session->set('update.available', '0');
            $session->set('update.core.count', 0);
            $session->set('update.module.count', 0);
        }

        return $this->responseAJAX([
            'status' => 'success',
            'data'   => $result
        ]);
    }
}
