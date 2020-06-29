package webpan.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import webpan.dao.ManagerDao;
import webpan.service.ManagerService;

@Transactional
@Service("ManagerService")
public class ManagerServiceImpl implements ManagerService 
{
	@Resource
	private ManagerDao mDao;
}
