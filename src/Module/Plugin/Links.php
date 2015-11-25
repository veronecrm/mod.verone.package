<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Package\Plugin;

use CRM\App\Module\Plugin;

class Links extends Plugin
{
  public function dashboard()
  {
    $result = [];

    if($this->acl('mod.Package.Package', 'mod.Package')->isAllowed('core.module'))
    {
      $result[] = [
        'ordering' => 40,
        'icon' => 'fa fa-cubes',
        'icon-type' => 'class',
        'name' => $this->t('modNamePackage'),
        'href' => $this->createUrl('Package', 'Package', 'index')
      ];
    }

    if($this->acl('mod.Package.Update', 'mod.Package')->isAllowed('core.module'))
    {
      $result[] = [
        'ordering' => 40,
        'icon' => 'fa fa-circle-o-notch',
        'icon-type' => 'class',
        'name' => $this->t('packageUpdates'),
        'href' => $this->createUrl('Package', 'Update')
      ];
    }

    return $result;
  }
}
