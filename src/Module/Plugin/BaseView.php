<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Package\Plugin;

use CRM\App\Module\Plugin;

class BaseView extends Plugin
{
  public function notificator()
  {
    if($this->request()->getSession()->get('update.available') === '1')
    {
      $core   = $this->request()->getSession()->get('update.core.count');
      $module = $this->request()->getSession()->get('update.module.count');

      return '<div class="notificator">
          <div class="notificator-btn ring"><i class="fa fa-bell"></i></div>
          <div class="notificator-container">
            <div class="notificator-inner">
              <h3><i class="fa fa-circle-o-notch pull-right"></i> '.$this->t('packageUpdateUpdatesAvailable').'</h3>
              <p>'.($core ? $this->t('packageUpdateSystemUpdates').': 1<br />' : '').($module ? $this->t('packageUpdateModulesUpdates').': '.$module : '').'</p>
              <a href="'.$this->createUrl('Package', 'Update', 'index').'" class="btn btn-default">'.$this->t('packageUpdateGotoUpdates').' &nbsp; <i class="fa fa-arrow-right"></i></a>
            </div>
          </div>
        </div>';
    }
  }

  public function bodyEnd()
  {
    if($this->request()->getSession()->get('update.checked') !== '1')
    {
      return "<script>APP.AJAX.call({url:APP.createUrl('Package','Update','check')});</script>";
    }
  }
}
