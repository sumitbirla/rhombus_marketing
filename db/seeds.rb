SearchPath.create(short_code: 'e', url: '/admin/marketing/email_subscribers', description: 'Search for an email subscriber')

Permission.create(section: 'marketing', resource: 'admin', action: 'login')

Permission.create(section: 'marketing', resource: 'email_list', action: 'read')
Permission.create(section: 'marketing', resource: 'email_list', action: 'create')
Permission.create(section: 'marketing', resource: 'email_list', action: 'update')
Permission.create(section: 'marketing', resource: 'email_list', action: 'destroy')

Permission.create(section: 'marketing', resource: 'email_subscriber', action: 'read')
Permission.create(section: 'marketing', resource: 'email_subscriber', action: 'create')
Permission.create(section: 'marketing', resource: 'email_subscriber', action: 'update')
Permission.create(section: 'marketing', resource: 'email_subscriber', action: 'destroy')

Permission.create(section: 'marketing', resource: 'email_blast', action: 'read')
Permission.create(section: 'marketing', resource: 'email_blast', action: 'create')
Permission.create(section: 'marketing', resource: 'email_blast', action: 'update')
Permission.create(section: 'marketing', resource: 'email_blast', action: 'destroy')
Permission.create(section: 'marketing', resource: 'email_blast', action: 'approve')

Permission.create(section: 'marketing', resource: 'affiliate_campaign', action: 'read')
Permission.create(section: 'marketing', resource: 'affiliate_campaign', action: 'create')
Permission.create(section: 'marketing', resource: 'affiliate_campaign', action: 'update')
Permission.create(section: 'marketing', resource: 'affiliate_campaign', action: 'destroy')